class ContactMailer < ActionMailer::Base
  default :from => "no-reply@ontheway.com"
  layout 'mailer'
  
  def contact_email(info)
    @info = info
    mail(:to => ADMIN_EMAIL, :subject => 'Feedback/Questions on OnTheWay')
  end

  def invite_email(sender, recipients)
    @sender, @recipients = sender, recipients
    mail(:from => @sender.email, :to => @recipients, :subject => 'Invitation to join OnTheWay')
  end
end
