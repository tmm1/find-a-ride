class Ride < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with DuplicateRideValidator
  
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

  attr_accessible :type, :orig, :dest, :start_date, :start_time, :vehicle, :payment, :notes
  
  def request?
    type.eql? 'RideRequest'
  end
  
  def offer?
    type.eql? 'RideOffer'
  end
 
  def deletable?
    ((ride_time < Time.now) and (HookUp.where(:hookable_id => id).empty? or HookUp.where(:hookable_id => id).not_closed.empty?)) or
      HookUp.where(:hookable_id => id).empty?
  end

  def owner?(u)
    user_id.eql? u.id
  end

  private

  def assign_attribs
    self.ride_time = Helper.to_datetime(self.start_date, self.start_time)
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
#  payment     :string(255)
#  notes       :string(3000)
#

