class UserLocation < ActiveRecord::Base 
  belongs_to :user
  belongs_to :location
end

# == Schema Information
#
# Table name: user_locations
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  location_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

