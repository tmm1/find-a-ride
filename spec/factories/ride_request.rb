Factory.define :ride_request do |r|
  r.association :origin, :factory => :location
  r.association :destination, :factory => :location
  r.ride_time   "2012-03-21 01:30:00"
  r.vehicle     "2-Wheeler"
  r.association :requestor, :factory => :user
end