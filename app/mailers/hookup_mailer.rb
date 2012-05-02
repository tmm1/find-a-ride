class HookupMailer < ActionMailer::Base
  @queue = :emails

  helper :hook_ups
  default :from => "no-reply@ontheway.com"
  layout 'mailer'

  def self.perform(method, hook_up_id, mobile)
    hook_up = HookUp.find(hook_up_id)
    email = self.send(method, hook_up, mobile)
    email.deliver
  end

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
    mail(:to => @hook_up.contactee.email, :from => @hook_up.contacter.email, :subject => 'Message from OnTheWay user')
  end
end
