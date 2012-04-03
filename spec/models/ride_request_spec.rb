require 'spec_helper'

describe RideRequest do
  describe "#search" do
    before(:all) do
      Ride.destroy_all
      @ride_request1 = Factory(:ride_request, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => 'four_wheeler')
      @ride_request2 = Factory(:ride_request, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => 'four_wheeler')
      @ride_request3 = Factory(:ride_request, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 02:00:00 pm', :vehicle => 'four_wheeler')
      @ride_request4 = Factory(:ride_request, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 02:30:00 pm', :vehicle => 'four_wheeler')
      @ride_request5 = Factory(:ride_request, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 03:30:00 pm', :vehicle => 'four_wheeler')
      @ride_request6 = Factory(:ride_request, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 04:30:00 pm', :vehicle => 'four_wheeler')
      @ride_request7 = Factory(:ride_request, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => 'two_wheeler')
      @ride_request8 = Factory(:ride_request, :orig => 'Madhapur', :dest => 'Miyapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => 'four_wheeler')
      @ride_request9 = Factory(:ride_request, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:00:00 pm', :vehicle => 'four_wheeler')
      @ride_request10 = Factory(:ride_request, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:00:00 pm', :vehicle => 'four_wheeler')
      @ride_request11 = Factory(:ride_request, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 04:30:00 pm', :vehicle => 'any')
      @ride_request10.requestor.update_attribute(:inactive, true)
    end

    it 'should return results for search criteria 1' do
      params = {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => 'four_wheeler'}
      results = RideRequest.search(params)
      results.should have(4).things
      results.should == [@ride_request9, @ride_request1, @ride_request2, @ride_request3]
      results.should_not include [@ride_request4, @ride_request5, @ride_request6, @ride_request7, @ride_request8, @ride_request10, @ride_request11]
    end

    it 'should return results for search criteria 2' do
      params = {:orig => 'Madhapur', :dest => 'Miyapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => 'four_wheeler'}
      results = RideRequest.search(params)
      results.should have(1).things
      results.should include @ride_request8
      results.should_not include [@ride_request2, @ride_request3, @ride_request9, @ride_request4, @ride_request5, @ride_request6, @ride_request7, @ride_request1, @ride_request10, @ride_request11]
    end

    it 'should return results for search criteria 3' do
      params = {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => 'two_wheeler'}
      results = RideRequest.search(params)
      results.should have(1).things
      results.should include @ride_request7
      results.should_not include [@ride_request2, @ride_request3, @ride_request9, @ride_request4, @ride_request5, @ride_request6, @ride_request8, @ride_request1, @ride_request10, @ride_request11]
    end
    
    it 'should return results for search criteria 4' do
      params = {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 04:30:00 pm', :vehicle => 'four_wheeler'}
      results = RideRequest.search(params)
      results.should have(2).things
      results.should == [@ride_request6, @ride_request11]
      results.should_not include [@ride_request2, @ride_request3, @ride_request9, @ride_request4, @ride_request5, @ride_request7, @ride_request8, @ride_request1, @ride_request10]
    end

    it 'should not return results for search criteria 1' do
      params = {:orig => 'Miyapur', :dest => 'Kothaguda', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => 'two_wheeler'}
      results = RideRequest.search(params)
      results.should have(0).things
    end

    it 'should not return results for search criteria 2' do
      params = {:orig => 'Madhapur', :dest => 'Miyapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 02:30:00 pm', :vehicle => 'four_wheeler'}
      results = RideRequest.search(params)
      results.should have(0).things
    end
  end
end



# == Schema Information
#
# Table name: rides
#
#  id          :integer(4)      not null, primary key
#  origin      :integer(4)
#  destination :integer(4)
#  ride_time   :datetime
#  fulfilled   :boolean(1)
#  vehicle     :string(255)
#  user_id     :integer(4)
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

