require "spec_helper"

describe HookupMailer do

  before(:all) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    @hook_up = Factory(:hook_up)
  end
  
  describe '#ride requestor hook-up email' do
    before(:each) do
      @hook_up.hookable_type = "RideRequest"
      ActionMailer::Base.deliveries.clear
    end
    it 'should deliver the email successfully' do
      HookupMailer.ride_requestor_email(@hook_up,@hook_up.mobile).deliver
      ActionMailer::Base.deliveries.size.should == 1
    end
    it 'should deliver the email with the correct info' do
      @hook_up.mobile = '9999988888'
      email = HookupMailer.ride_requestor_email(@hook_up,@hook_up.mobile).deliver
      email.subject.should == 'Message from OnTheWay user'
      email.to.should == [@hook_up.contactee.email]
      email.body.include?("#{@hook_up[:message]}").should be_true
      email.body.include?("#{@hook_up[:mobile]}").should be_true
    end
  end
  
  describe '#ride offerer hook-up email' do
    before(:each) do
      @hook_up.hookable_type = "RideOffer"
      ActionMailer::Base.deliveries.clear
    end
    it 'should deliver the email successfully' do
      HookupMailer.ride_offerer_email(@hook_up,@hook_up.mobile).deliver
      ActionMailer::Base.deliveries.size.should == 1
    end
    it 'should deliver the email with the correct info' do
      email = HookupMailer.ride_offerer_email(@hook_up,@hook_up.mobile).deliver
      email.subject.should == 'Message from OnTheWay user'
      email.to.should == [@hook_up.contactee.email]
      email.body.include?("#{@hook_up[:message]}").should be_true
    end
  end
    
end
