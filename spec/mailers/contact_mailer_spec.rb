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
      email.subject.should == 'Message from OnTheWay user' 
      email.to.should == [ADMIN_EMAIL]
      email.body.include?("#{@info[:name]}").should be_true
      email.body.include?("#{@info[:email]}").should be_true
      email.body.include?("#{@info[:about]}").should be_true
      email.body.include?("#{@info[:comments]}").should be_true
    end
  end

  describe '#referral email' do
    before(:each) do
      @sender = Factory(:user)
      @recipient = {:name => 'john emburey', :email => 'john@gmail.com'}
      ActionMailer::Base.deliveries.clear
    end

    it 'should deliver the email successfully' do
      email = ContactMailer.referral_email(@sender, @recipient).deliver
      ActionMailer::Base.deliveries.size.should == 1
    end

    it 'should deliver the email with the correct info' do
      email = ContactMailer.referral_email(@sender, @recipient).deliver
      email.subject.should == 'Invite to OnTheWay'
      email.to.should == [@recipient[:email]]
      email.body.include?('Sign up').should be_true
      email.body.include?(@sender.full_name).should be_true
      email.body.include?(@sender.email).should be_true
    end
  end
end
