class Ride < ActiveRecord::Base
  belongs_to :ride_origin, :class_name => 'Location', :foreign_key => 'origin'
  belongs_to :ride_destination, :class_name => 'Location', :foreign_key => 'destination'
  
  before_create :assign_attribs
  
  validates :orig, :dest, :start_date, :start_time, :presence => true
  validates :start_time, :time => true, :allow_nil => true
  validates :orig, :dest, :location => true, :allow_nil => true
  
  cattr_accessor :orig
  cattr_accessor :dest
  cattr_accessor :start_date
  cattr_accessor :start_time
  
  attr_accessor :orig, :dest, :start_date, :start_time
  attr_accessible :orig, :dest, :start_date, :start_time
 
  private

  def assign_attribs
    self.ride_time = "#{self.start_date} #{self.start_time}".to_datetime
    self.origin = Location.find_by_name(self.orig).id
    self.destination = Location.find_by_name(self.dest).id
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

