class RideOffer < Ride
  belongs_to :offerer, :class_name => 'User', :foreign_key => 'user_id'
  has_many :hook_ups, :as => :hookable
  
  def self.search(params)
    orig = Location.find_by_name(params[:orig])
    dest = Location.find_by_name(params[:dest])
    ride_time = Helper.to_datetime(params[:start_date], params[:start_time])
    time_range = ([ride_time - 30.minutes, Time.now].max)..(ride_time + 30.minutes)
    active_offerers = User.active.select(:id)
    params[:vehicle] = params[:vehicle] == 'any' ? ['two_wheeler', 'four_wheeler'] : params[:vehicle]
    RideOffer.where(:origin => orig.id, :destination => dest.id, :vehicle => params[:vehicle], :ride_time => time_range, :user_id => active_offerers).order('ride_time ASC')
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

