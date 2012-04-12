Factory.define :hook_up do |h| #TODO: fix this messiness.
  h.contacter_id User.last.id
  h.contactee_id User.first.id
  h.hookable_id Ride.last.id
  h.hookable_type Ride.last.type
  h.message {Faker::Lorem.sentence}
end
