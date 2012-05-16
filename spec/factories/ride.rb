Factory.define :ride do |r|
  r.orig Location.where(:city_id => 1).collect{|l| l.name}.sample
  r.dest Location.where(:city_id => 1).collect{|l| l.name}.sample
  r.start_date "10/12/2012"
  r.start_time "10/12/2012 01:30:00"
  r.vehicle ["two_wheeler", "four_wheeler"].sample
  r.type  ['RideOffer', 'RideRequest'].sample
  r.payment ["cash", "nothing"].sample
  r.current_city "Hyderabad"
  r.notes Faker::Lorem.sentence(2)
end
