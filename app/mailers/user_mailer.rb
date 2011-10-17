class UserMailer < ActionMailer::Base
  default :from => "champ@find-a-ride.com"
  
  def contact_rider_email(from_user, to_user)
    @to_user = to_user
    @from_user = from_user
    mail(:to => to_user["email"], :subject => 'Find-a-Ride user looking to share a ride')
  end
  
  def contact_driver_email(from_user, to_user)
    @to_user = to_user
    @from_user = from_user
    mail(:to => to_user["email"], :subject => 'Find-a-Ride user looking to offer a ride')
  end
end
