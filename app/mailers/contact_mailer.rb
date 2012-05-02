class ContactMailer < ActionMailer::Base
  @queue = :emails
  default :from => "no-reply@ontheway.com"
  layout 'mailer'
  
  def self.perform(method, *args)
    email = self.send(method, *args)
    email.deliver
  end

  def contact_email(info)
    @info = info
    mail(:to => ADMIN_EMAIL, :subject => 'Feedback/Questions on OnTheWay')
  end

  def invite_email(sender_id, recipients)
    @sender = User.find(sender_id)
    @recipients = recipients.collect {|r| r.strip}
    mail(:from => @sender.email, :to => @recipients, :subject => 'Invitation to join OnTheWay')
  end
end
