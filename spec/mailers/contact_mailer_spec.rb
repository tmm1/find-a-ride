require "spec_helper"

describe ContactMailer do
  before(:all) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
  end
  
  describe '#contact email' do
    before(:each) do
      @info = {'name' => 'john emburey', 'email' => 'john@gmail.com', 'about' => 'General Feedback', 'comments' => 'Hey! this is a great site, keep it going!' }
      ActionMailer::Base.deliveries.clear
    end
    
    it 'should deliver the email successfully' do
      email = ContactMailer.contact_email(@info).deliver
      ActionMailer::Base.deliveries.size.should == 1
    end

    it 'should deliver the email with the correct info' do
      email = ContactMailer.contact_email(@info).deliver
      email.subject.should == 'Feedback/Questions on OnTheWay' 
      email.to.should == [ADMIN_EMAIL]
      email.body.include?("#{@info['name']}").should be_true
      email.body.include?("#{@info['email']}").should be_true
      email.body.include?("#{@info['about']}").should be_true
      email.body.include?("#{@info['comments']}").should be_true
    end
  end

  describe '#invite email' do
    before(:each) do
      @sender = Factory(:user)
      @recipients = ['john@gmail.com', 'jim@yahoo.com']
      ActionMailer::Base.deliveries.clear
    end

    it 'should deliver the emails successfully' do
      email = ContactMailer.invite_email(@sender, @recipients).deliver
      ActionMailer::Base.deliveries.size.should == 1
    end

    it 'should deliver the emails with the correct info' do
      email = ContactMailer.invite_email(@sender, @recipients).deliver
      email.subject.should == 'Invitation to join OnTheWay'
      email.from.should == [@sender.email]
      email.to.should have(2).things
      email.body.include?('Sign up').should be_true
      email.body.include?(@sender.full_name).should be_true
      email.body.include?(@sender.email).should be_true
    end
  end

  describe '#perform' do
    before(:each) do
      @email = mock('email', :deliver => true)
    end

    it 'should send contact_email' do
      info = {:name => 'john emburey', :email => 'john@gmail.com', :comments => 'nothing here...'}
      ContactMailer.should_receive(:send).with(:contact_email, info).and_return(@email)
      ContactMailer.perform(:contact_email, info)
    end

    it 'should send invite_email' do
      user = mock_model(User)
      recipients = ['invitee1@gmail.com', 'invitee2@gmail.com']
      ContactMailer.should_receive(:send).with(:invite_email, user.id, recipients).and_return(@email)
      ContactMailer.perform(:invite_email, user.id, recipients)
    end
  end
end
