LOCATION_CONFIG.each_pair do |city, locations|
  p "Seeding location data for #{city}"
  if City.find_by_name(city)
    p "Location data already exists for #{city}"
  else
    City.create(:name => city)
    city = City.find_by_name(city)
    locations.values.first.each do |location|
      city.locations.create(:name => location) unless location.blank?
    end
  end
end
