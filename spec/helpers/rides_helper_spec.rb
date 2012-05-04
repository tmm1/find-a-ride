require 'spec_helper'

describe RidesHelper do

  include Devise::TestHelpers

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
  
  describe '#Other info with payment desc' do
    it 'should return payment/other info for ride offer' do
      ride_offer = Factory(:ride_offer, :payment => 'cash')
      helper.other_info_content(ride_offer).include?('Expects cash in return for the ride')
      ride_offer.notes = 'additional information'
      helper.other_info_content(ride_offer).include?('additional information')
    end
    
    it 'should return payment/other info for ride request' do
      ride_request = Factory(:ride_request, :payment => 'nothing')
      helper.other_info_content(ride_request).include?('Can pay nothing in return for the ride')
      ride_request.notes = 'other information'
      helper.other_info_content(ride_request).include?('other information')
    end
    
    it 'should return already hooked up' do
      ride_request = Factory(:ride_request, :payment => 'nothing')
      helper.other_info_content(ride_request, true).should == 'Ah, It looks like you already might be in touch with this user!'
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

    it 'should return string any' do
      ride_request = Factory(:ride_request, :vehicle => 'any')
      helper.vehicle_type_image(ride_request).should == 'any'
    end
  end
  
  describe '#humanize time' do
    it 'should return with today' do
      helper.humanize_time(Time.now).include?('Today').should be true
    end
    it 'should return with tomorrow' do
      helper.humanize_time(Time.now.advance(:days => 1)).include?('Tomorrow').should be true
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
      helper.vehicle_type_collection.should == [['I don\'t care', 'any'],['Four-Wheeler', 'four_wheeler'], ['Two-Wheeler', 'two_wheeler'] ]
    end
  end
  
  describe '#payment type collection' do
    it 'should return the collection' do
      helper.payment_type_collection(['pay', 'empty']).should == [['pay', 'cash'], ['empty', 'nothing']]
    end
  end

  describe '#user_uuid' do
    it 'should return user uuid for the divs' do
      uuid = helper.user_uuid
      assert  UUID.validate(uuid), 'default'
    end
  end
  
  describe '#hookup label' do
    it 'should return offer for ride request' do
      ride_request = Factory(:ride_request)
      helper.hookup_label(ride_request).should == 'Offer'
    end

    it 'should return request for ride offer' do
      ride_offer = Factory(:ride_offer)
      helper.hookup_label(ride_offer).should == 'Request'
    end
  end

  describe '#ride_details_json' do
    it 'should return json-ised hash of values' do
      offerer, requestor = Factory(:user), Factory(:user)
      sign_in requestor
      ride_offer = Factory(:ride_offer, :offerer => offerer, :type => 'RideOffer')
      json = helper.ride_details_json(ride_offer, "someString")
      hash = ActiveSupport::JSON.decode(json)
      hash.class.should == Hash
      hash.keys.count.should == 12
      hash['mobile'].should == requestor.mobile
      hash['create_hookup_path'].should == user_hook_ups_path(requestor, :ride_offer_id => ride_offer.id)
      hash['header'].should == "Request a ride from #{offerer.full_name}"
    end

    it 'should not raise any error if any argument is nil' do
      lambda {
        helper.ride_details_json(nil, nil)
      }.should_not raise_error
    end
  end

  describe '#ride time collection' do
    it 'should return the collection' do
      helper.ride_time_collection.should == {"today" => "Today","#{2.days.from_now.end_of_day() }"   => "2 Days from now " ,"#{7.days.from_now.end_of_day() }"   => "1 week from now", "#{14.days.from_now.end_of_day() }"  => "2 weeks from now"}
    end
  end

end
