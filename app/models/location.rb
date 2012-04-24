class Location < ActiveRecord::Base
  belongs_to :city

  def self.find_by_name(name)
    where("LOWER(locations.name) = LOWER(?)", name).first
  end
end


# == Schema Information
#
# Table name: locations
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  city_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

