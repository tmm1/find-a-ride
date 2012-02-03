# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
APP_CITIES.each do |city|
  City.create(:name => city)
end

APP_LOCATIONS.each do |city,locations|
    city = City.find_by_name(city)
  locations.each do |location|
    city.locations.create(:name => location) unless location.blank?
  end
end  