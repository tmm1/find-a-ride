Factory.define :hook_up do |h| 
  h.association :contacter, :factory => :user
  h.association :contactee, :factory => :user
  h.association :hookable, :factory => :ride
  h.message {Faker::Lorem.sentence}
end
