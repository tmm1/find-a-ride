class UserMailer < ActionMailer::Base
  default :from => "champ@find-a-ride.com"
  
  def contact_rider_email(ride, message)
    @from_user = ride.sharer.try(:ext_attributes) || ride.humanized_user_info
    @to_user = ride.offerer.attributes
    @message = message
    mail(:to => @to_user["email"], :subject => 'Find-a-Ride user looking to share a ride')
  end
  
  def contact_driver_email(ride, message)
    @from_user = ride.offerer.try(:ext_attributes) || ride.humanized_user_info
    @to_user = ride.sharer.attributes
    @message = message
    mail(:to => @to_user["email"], :subject => 'Find-a-Ride user looking to offer a ride')
  end
end
