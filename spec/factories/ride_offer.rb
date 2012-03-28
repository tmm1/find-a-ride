Factory.define :ride_offer do |r|
  r.orig "Madhapur"
  r.dest  "Kondapur"
  r.start_date "10/12/2012"
  r.start_time "10/12/2012 01:30:00 pm"
  r.vehicle "2-Wheeler"
  r.association :offerer, :factory => :user
end
