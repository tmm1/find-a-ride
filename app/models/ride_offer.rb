class RideOffer < Ride
  belongs_to :offerer, :class_name => 'User', :foreign_key => 'user_id'
  has_many :hook_ups, :as => :hookable, :finder_sql => Proc.new {
    %|SELECT hook_ups.* FROM hook_ups WHERE (hook_ups.hookable_id = #{self.id.to_i} AND hook_ups.hookable_type = 'RideOffer')|
  }
  
  def self.search(params)
    orig = Location.find_by_name(params[:orig]) if !params[:orig].blank?
    dest = Location.find_by_name(params[:dest]) if !params[:dest].blank?
    query = {}
    query.deep_merge!(:origin => orig.try(:id)) if !params[:orig].blank?
    query.deep_merge!(:destination => dest.try(:id))  if !params[:dest].blank?
    if !params[:start_date].nil?      
     ride_time = Helper.to_datetime(params[:start_date], params[:start_time])
     time_range = ([ride_time - 30.minutes, Time.now].max)..(ride_time + 30.minutes)
    else
     time_range = (params[:ride_time].blank? || params[:ride_time] == "today") ? (Time.now..0.day.from_now.end_of_day()) : (Time.now)..(params[:ride_time].to_datetime)
    end
    active_offerers = params[:user_id] ? User.other_active(params[:user_id]).select(:id) : User.active().select(:id)
    query.deep_merge!({:user_id => active_offerers})
    params[:vehicle] = (params[:vehicle].blank? || params[:vehicle] == 'any' ) ? ['two_wheeler', 'four_wheeler'] : params[:vehicle]
    RideOffer.for_city(params[:city]).where(query.deep_merge!({:vehicle => params[:vehicle], :ride_time => time_range})).order('ride_time ASC')
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

