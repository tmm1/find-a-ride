class RideRequest < Ride
  belongs_to :requestor, :class_name => 'User', :foreign_key => 'user_id'

  has_many :hook_ups, :as => :hookable, :finder_sql => Proc.new {
    %|SELECT hook_ups.* FROM hook_ups WHERE (hook_ups.hookable_id = #{self.id.to_i} AND hook_ups.hookable_type = 'RideRequest')|
  }

  def self.search(params)
    orig = Location.find_by_name(params[:orig])
    dest = Location.find_by_name(params[:dest])
    ride_time = Helper.to_datetime(params[:start_date], params[:start_time])
    time_range = ([ride_time - 30.minutes, Time.now].max)..(ride_time + 30.minutes)
    active_requestors = User.other_active(params[:user_id]).select(:id)
    vehicle_types = ['any'] << params[:vehicle]
    RideRequest.where(:origin => orig.id, :destination => dest.id, :vehicle => vehicle_types, :ride_time => time_range, :user_id => active_requestors).order('ride_time ASC')
  end
end


# == Schema Information
#
# Table name: rides
#
#  id          :integer(4)      not null, primary key
#  origin      :integer(4)
#  destination :integer(4)
#  ride_time   :datetime
#  fulfilled   :boolean(1)
#  vehicle     :string(255)
#  user_id     :integer(4)
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  payment     :string(255)
#  notes       :string(3000)
#

