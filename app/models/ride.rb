class Ride < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with DuplicateRideValidator
  
  default_scope lambda { where("rides.expires_on >= ?", Date.today) }

  # Ride offers in the system
  scope :offers, lambda{ where("type = ?", "RideOffer").order('ride_time') }
  
  # DynamicDefaultScoping to be included after default_scope
  include DynamicDefaultScoping

  belongs_to :ride_origin, :class_name => 'Location', :foreign_key => 'origin'
  belongs_to :ride_destination, :class_name => 'Location', :foreign_key => 'destination'
  
  before_create :assign_attribs
  
  RIDETIME =  {"today"                              => "Today",
               "tomorrow"  => "Tomorrow",
               "#{2.days.from_now.end_of_day() }"   => "2 Days from now " ,
               "#{7.days.from_now.end_of_day() }"   => "1 week from now",
               "#{14.days.from_now.end_of_day() }"  => "2 weeks from now"}
             

  validates :orig, :dest, :start_date, :start_time, :presence => true
  validates :start_time, :start_date, :date_time => true
  validates :start_time, :time => true
  validates :orig, :dest, :location => true
  validates_length_of :notes, :maximum => 300
  
  attr_accessor :orig
  attr_accessor :dest
  attr_accessor :start_date
  attr_accessor :start_time

  attr_accessible :type, :orig, :dest, :start_date, :start_time, :vehicle, :payment, :notes
  
  def request?
    type.eql? 'RideRequest'
  end
  
  def offer?
    type.eql? 'RideOffer'
  end
 
  def deletable?
    hook_ups.empty? or hook_ups.none? {|hu| !hu.closed?}
  end

  def humanize_type
    self.class.to_s.underscore.humanize.downcase
  end


  def self.filter(params)
    orig = Location.find_by_name(params[:orig]) if params[:orig]
    dest = Location.find_by_name(params[:dest]) if params[:dest]
    query = {:type => "RideOffer"}
    query.deep_merge!(:origin => orig.id) if orig
    query.deep_merge!(:destination => dest.id) if dest
    ride_time = {:ride_time => (params[:ride_time].blank? || params[:ride_time] == "today") ? (Time.now..0.day.from_now.end_of_day()) : (params[:ride_time] == "tomorrow" ? (Time.now.tomorrow)..(Time.now.tomorrow.end_of_day()): (Time.now)..(params[:ride_time].to_datetime))}
    query.deep_merge!(ride_time)
    vehicle_type = (params[:vehicle].blank? || params[:vehicle] == 'any') ? ['any' , 'four_wheeler','two_wheeler']  : params[:vehicle]
    query.deep_merge!(:vehicle => vehicle_type)
    active_offerers = User.other_active(params[:user_id]).select(:id)
    query.deep_merge!({:user_id => active_offerers})
    Ride.where(query).order('ride_time ASC')
  end

  private

  def assign_attribs
    self.ride_time = Helper.to_datetime(self.start_date, self.start_time)
    self.origin = Location.find_by_name(self.orig).id
    self.destination = Location.find_by_name(self.dest).id
    self.expires_on = self.ride_time.to_date + 15.days
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

