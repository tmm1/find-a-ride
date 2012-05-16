Factory.define :ride_request do |r|
  r.orig Location.where(:city_id => 1).collect{|l| l.name}.sample
  r.dest Location.where(:city_id => 1).collect{|l| l.name}.sample
  r.start_date "10/12/2012"
  r.start_time "10/12/2012 01:30:00"
  r.vehicle     ["two_wheeler", "four_wheeler"].sample
  r.payment ["cash", "nothing"].sample
  r.notes Faker::Lorem.sentence(2)
  r.association :requestor, :factory => :user
  r.type 'RideRequest'
  r.current_city "Hyderabad"
end
