require 'spec_helper'

describe HookUpsHelper do

  describe '#ride_time' do
    it 'should return formatted time with today' do
      HookUpsHelper.formatted_ride_time(Time.now).include?('today').should be true
    end
    it 'should return formatted time with tomorrow' do
      HookUpsHelper.formatted_ride_time(Time.now.advance(:days => 1)).include?('tomorrow').should be true
    end
    it 'should return formatted time with on' do
      HookUpsHelper.formatted_ride_time(Time.now.advance(:days => 3)).include?('on').should_not be nil
    end
  end

end
