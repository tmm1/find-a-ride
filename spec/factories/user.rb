Factory.define :user do |f|
  f.first_name {Faker::Name.first_name}
  f.last_name {Faker::Name.last_name}
  f.email {Faker::Internet.email}
  f.password 'test1234'
  f.password_confirmation 'test1234'
  f.mobile '8091221221'
  f.after_create { |u| u.confirm! }
end
