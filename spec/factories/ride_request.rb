Factory.define :ride_request do |r|
  r.orig "Madhapur"
  r.dest  "Kondapur"
  r.start_date "10/12/2012"
  r.start_time "10/12/2012 01:30:00 pm"
  r.vehicle "four_wheeler"
  r.association :requestor, :factory => :user
  r.payment "cash"
  r.notes "nothing much"
end
