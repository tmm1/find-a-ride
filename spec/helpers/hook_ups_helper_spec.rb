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
      helper.header_text('RideRequest').should == 'Request a ride from'
    end
    it 'should return for RideOffer type' do
      helper.header_text('RideOffer').should == 'Offer a ride to'
    end
  end
end
