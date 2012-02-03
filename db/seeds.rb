City.destroy_all
Location.destroy_all

LOCATION_CONFIG.each_pair do |city, locations|
  p "Seeding location data for #{city}"
  City.create(:name => city)
  city = City.find_by_name(city)
  locations.values.first.each do |location|
    city.locations.create(:name => location) unless location.blank?
  end
end