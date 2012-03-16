require "spec_helper"

describe ContactMailer do
  before(:all) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
  end
  
  describe '#contact email' do
    before(:each) do
      @info = {:name => 'john emburey', :email => 'john@gmail.com', :about => 'General Feedback', :comments => 'Hey! this is a great site, keep it going!' }
      ActionMailer::Base.deliveries.clear
    end
    
    it 'should deliver the email successfully' do
      email = ContactMailer.contact_email(@info).deliver
      ActionMailer::Base.deliveries.size.should == 1
    end

    it 'should deliver the email with the correct info' do
      email = ContactMailer.contact_email(@info).deliver
      email.subject.should == 'Message from Find.a.ride user' 
      email.to.should == [ADMIN_EMAIL]
      email.body.include?("#{@info[:name]}").should be_true
      email.body.include?("#{@info[:email]}").should be_true
      email.body.include?("#{@info[:about]}").should be_true
      email.body.include?("#{@info[:comments]}").should be_true
    end
  end

end
