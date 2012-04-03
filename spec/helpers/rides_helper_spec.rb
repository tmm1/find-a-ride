require 'spec_helper'

describe RidesHelper do
  describe '#user name' do
    it 'should return user name for the ride request' do
      ride_request = Factory(:ride_request)
      name = helper.user_name(ride_request)
      name.should_not be nil
      name.should == ride_request.requestor.full_name
    end
    
    it 'should return user name for the ride offer' do
      ride_offer = Factory(:ride_offer)
      name = helper.user_name(ride_offer)
      name.should_not be nil
      name.should == ride_offer.offerer.full_name
    end    
  end
  
  describe '#vehicle type image' do
    it 'should return 4 wheeler type image' do
      ride_request = Factory(:ride_request, :vehicle => 'four_wheeler')
      helper.vehicle_type_image(ride_request).should == image_tag('4-wheeler.png', :size => '30x30')
    end
    
    it 'should return 2 wheeler type image' do
      ride_request = Factory(:ride_request, :vehicle => 'two_wheeler')
      helper.vehicle_type_image(ride_request).should == image_tag('2-wheeler.png', :size => '40x40')
    end
  end
  
  describe '#humanize time' do
    it 'should return with today' do
      helper.humanize_time(Time.now).include?('today').should be true
    end
    it 'should return with tomorrow' do
      helper.humanize_time(Time.now.advance(:days => 1)).include?('tomorrow').should be true
    end
    it 'should return with actual date' do
      helper.humanize_time(Time.now.advance(:days => 3)).should_not be nil
    end
  end


  describe '#user id' do
    it 'should return user id for the ride request' do
      ride_request = Factory(:ride_request)
      id = helper.user_id(ride_request)
      id.should_not be nil
      id.should == ride_request.requestor.id
    end

    it 'should return user id for the ride offer' do
      ride_offer = Factory(:ride_offer)
      id = helper.user_id(ride_offer)
      id.should_not be nil
      id.should == ride_offer.offerer.id
    end
  end
  
  describe '#vehicle type collection' do
    it 'should return the collection' do
      helper.vehicle_type_collection.should == [['Four-Wheeler', 'four_wheeler'], ['Two-Wheeler', 'two_wheeler'], ['I don\'t care', 'any']]
    end
  end
end
