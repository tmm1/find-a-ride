Factory.define :user do |f|
  f.first_name {Faker::Name.first_name}
  f.last_name {Faker::Name.last_name}
  f.email {Faker::Internet.email}
  f.password 'test1234'
  f.password_confirmation 'test1234'
  f.origin 'Madhapur'
  f.destination 'Kondapur'
  f.rider true
  f.mobile '8091221221'
end
