require "spec_helper"

describe UserMailer do
  before(:all) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
  end
  describe '#contact_rider_email' do
    before(:each) do 
      @from_user = Factory(:user)
      @to_user = Factory(:user)
      ActionMailer::Base.deliveries.clear
    end
    
    it 'should send rider email for an authenticated user' do
      email = UserMailer.contact_rider_email(@from_user.attributes, @to_user.attributes).deliver
      ActionMailer::Base.deliveries.size.should == 1
      email.subject.should == 'Find-a-Ride user looking to share a ride' 
      email.to.should == [@to_user["email"]]
      email.body.include?("#{@from_user["name"]}").should be_true
      email.body.include?("#{@from_user["email"]}").should be_true
    end
    
    it 'should send rider email for an anonymous user' do
      from_user = {"name" => 'test from karthik', "email" => 'test@k.com'}
      email = UserMailer.contact_rider_email(from_user, @to_user.attributes).deliver
      ActionMailer::Base.deliveries.size.should == 1
      email.subject.should == 'Find-a-Ride user looking to share a ride' 
      email.to.should == [@to_user["email"]]
      email.body.include?("#{from_user["name"]}").should be_true
      email.body.include?("#{from_user["email"]}").should be_true
    end
  end
  
  describe '#contact_driver_email' do
     before(:each) do 
       @from_user = Factory(:user)
       @to_user = Factory(:user)
       ActionMailer::Base.deliveries.clear
     end

     it 'should send driver email for an authenticated user' do
       email = UserMailer.contact_driver_email(@from_user.attributes, @to_user.attributes).deliver
       ActionMailer::Base.deliveries.size.should == 1
       email.subject.should == 'Find-a-Ride user looking to offer a ride' 
       email.to.should == [@to_user["email"]]
       email.body.include?("#{@from_user["name"]}").should be_true
       email.body.include?("#{@from_user["email"]}").should be_true
     end

     it 'should send driver email for an anonymous user' do
       from_user = {"name" => 'test from karthik', "email" => 'test@k.com'}
       email = UserMailer.contact_driver_email(from_user, @to_user.attributes).deliver
       ActionMailer::Base.deliveries.size.should == 1
       email.subject.should == 'Find-a-Ride user looking to offer a ride' 
       email.to.should == [@to_user["email"]]
       email.body.include?("#{from_user["name"]}").should be_true
       email.body.include?("#{from_user["email"]}").should be_true
     end
   end
end
