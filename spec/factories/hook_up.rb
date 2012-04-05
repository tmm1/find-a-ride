Factory.define :hook_up do |h|
  h.association :contacter, :factory => :user
  h.association :contactee, :factory => :user
  h.association :hookable, :factory => :ride_request
  h.message {Faker::Lorem.paragraph}
  h.hookable_type 'RideRequest'
  h.association :hookable_id, :factory => :ride
end
