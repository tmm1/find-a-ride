class Devise::Mailer < ::ActionMailer::Base
  @queue = :emails
  
  def self.perform(method, record_id)
    record = User.find(record_id)
    email = self.send(method, record)
    email.deliver
  end
end
