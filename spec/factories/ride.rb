Factory.define :ride do |f|
  f.association :offerer, :factory => :user 
  f.association :sharer, :factory => :user 
  f.contact_date 1.day.ago
end
