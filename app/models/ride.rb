class Ride < ActiveRecord::Base
  has_one :ride_origin, :class_name => 'Location', :foreign_key => 'origin'
  has_one :ride_destination, :class_name => 'Location', :foreign_key => 'destination'
  
  before_save :do_ride


  validates :orig,:dest,:start_date, :start_time, :presence => true
  validate :start_is_time?
  
  cattr_accessor :orig
  cattr_accessor :dest
  cattr_accessor :start_date
  cattr_accessor :start_time
  attr_accessible :type,:orig, :dest, :start_date, :start_time, :vehicle
  
  private

  def do_ride
    self.ride_time = "#{self.start_date} #{self.start_time}".to_datetime
    self.origin = Location.find_by_name(self.orig).id if self.orig
    self.destination = Location.find_by_name(self.dest).id if self.dest
  end

  def start_is_time?
   begin
      timeObj = Time.parse(self.start_time)
      if !timeObj.is_a?(Time)
        errors.add(:start_time, 'must be a valid time')
      end
    rescue
      errors.add(:start_time, 'must be a valid time')
    end
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
#

