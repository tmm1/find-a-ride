class HookupMailer < ActionMailer::Base
  default :from => "no-reply@find-a-ride.com"
  layout 'mailer'

  def ride_requestor_email(hook_up, mobile = nil)
    setup_hook_up(hook_up, mobile)
  end

  def ride_offerer_email(hook_up, mobile = nil)
    setup_hook_up(hook_up, mobile)
  end

  def setup_hook_up(hook_up, mobile = nil)
    @hook_up = hook_up
    @message = hook_up.message
    @mobile = mobile
    mail(:to => @hook_up.contactee.email, :from => @hook_up.contacter.email, :subject => 'Message from Find.a.ride user')
  end

end
