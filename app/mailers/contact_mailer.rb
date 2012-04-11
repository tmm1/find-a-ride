class ContactMailer < ActionMailer::Base
  default :from => "no-reply@ontheway.com"
  layout 'mailer'
  
  def contact_email(info)
    @info = info
    mail(:to => ADMIN_EMAIL, :subject => 'Message from OnTheWay user')
  end

  def referral_email(sender, recipient)
    @sender, @recipient = sender, recipient
    mail(:from => @sender.email, :to => @recipient[:email], :subject => 'Invite to OnTheWay')
  end
end
