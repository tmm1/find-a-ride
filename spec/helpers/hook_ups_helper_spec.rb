require 'spec_helper'

describe HookUpsHelper do
  describe '#formatted_ride_time' do
    it 'should return formatted time with today' do
      helper.formatted_ride_time(Time.now).include?('today').should be true
    end
    it 'should return formatted time with tomorrow' do
      helper.formatted_ride_time(Time.now.advance(:days => 1)).include?('tomorrow').should be true
    end
    it 'should return formatted time with on' do
      helper.formatted_ride_time(Time.now.advance(:days => 3)).include?('on').should_not be nil
    end
  end
  
  describe '#header_text' do
    it 'should return for RideRequest type' do
      helper.header_text('ride_request').should == 'Offer a ride to'
    end
    it 'should return for RideOffer type' do
      helper.header_text('ride_offer').should == 'Request a ride from'
    end
  end
  
  describe '#activity_text' do
    before(:all) do
      @user1 = Factory(:user)
      @user2 = Factory(:user)
      @ride1 = Factory(:ride_request)
      @ride2 = Factory(:ride_offer)
      @hook_up1 = Factory(:hook_up, :contacter => @user1, :contactee => @user2, :hookable => @ride1)
      @hook_up2 = Factory(:hook_up, :contacter => @user1, :contactee => @user2, :hookable => @ride2)
    end
    
    it 'should return appropriate activity text for request' do
      helper.activity_text(@hook_up1, @user1).should == "You offered #{@user2.try(:full_name)} a ride"
      helper.activity_text(@hook_up1, @user2).should == "#{@user1.try(:full_name)} offered you a ride"
    end
    
    it 'should return appropriate activity text for offer' do
      helper.activity_text(@hook_up2, @user1).should == "You requested #{@user2.try(:full_name)} a ride"
      helper.activity_text(@hook_up2, @user2).should == "#{@user1.try(:full_name)} requested you a ride"
    end
  end
end
