Factory.define :alert do |h| 
  h.association :sender, :factory => :user
  h.association :receiver, :factory => :user
  h.message {Faker::Lorem.paragraph}
end
