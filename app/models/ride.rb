class Ride < ActiveRecord::Base
  has_one :origin, :class_name => 'Location', :foreign_key => 'origin'
  has_one :destination, :class_name => 'Location', :foreign_key => 'destination'
  
  cattr_accessor :orig
  cattr_accessor :dest
  cattr_accessor :start_date
  cattr_accessor :start_time
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

