Factory.define :alert do |h| 
  h.association :sender, :factory => :user
  h.association :receiver, :factory => :user
  h.message {Faker::Lorem.sentence}
  h.association :hook_up, :factory => :hook_up
end
