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
               
  validates :orig, :dest, :start_date, :start_time, :presence => true
  validates :start_time, :start_date, :date_time => true
  validates :start_time, :time => true
  validates :orig, :dest, :location => true
  validates_length_of :notes, :maximum => 300
  
  attr_accessor :orig
  attr_accessor :dest
  attr_accessor :start_date
  attr_accessor :start_time
  attr_accessor :current_city

  attr_accessible :type, :orig, :dest, :start_date, :start_time, :vehicle, :payment, :notes,:current_city

  def self.for_city(city)
    joins('INNER JOIN locations ON rides.origin = locations.id INNER JOIN cities ON locations.city_id = cities.id').where('cities.name' => city)
  end
  
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

  private

  def assign_attribs
    city = City.find_by_name(self.current_city)    
    self.ride_time = Helper.to_datetime(self.start_date, self.start_time)
    self.origin = city.locations.find_by_name(self.orig).id
    self.destination = city.locations.find_by_name(self.dest).id
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

