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
      ride_request = Factory(:ride_request, :vehicle => '4-Wheeler')
      helper.vehicle_type_image(ride_request).should == image_tag('4-wheeler.png', :size => '30x30')
    end
    
    it 'should return 2 wheeler type image' do
      ride_request = Factory(:ride_request, :vehicle => '2-Wheeler')
      helper.vehicle_type_image(ride_request).should == image_tag('2-wheeler.png', :size => '40x40')
    end
  end
end