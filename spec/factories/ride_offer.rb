Factory.define :ride_offer do |r|
  r.orig Location.all.collect{|l| l.name}.sample
  r.dest Location.all.collect{|l| l.name}.sample
  r.start_date "10/12/2012"
  r.start_time "10/12/2012 01:30:00"
  r.vehicle     ["two_wheeler", "four_wheeler"].sample
  r.payment ["cash", "nothing"].sample
  r.notes "nothing much"
  r.association :offerer, :factory => :user
end
