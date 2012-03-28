require 'spec_helper'

describe RideOffer do
  describe "#search" do
    before(:all) do
      Ride.destroy_all
      @ride_offer1 = Factory(:ride_offer, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => '4-Wheeler')
      @ride_offer2 = Factory(:ride_offer, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => '4-Wheeler')
      @ride_offer3 = Factory(:ride_offer, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 02:00:00 pm', :vehicle => '4-Wheeler')
      @ride_offer4 = Factory(:ride_offer, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 02:30:00 pm', :vehicle => '4-Wheeler')
      @ride_offer5 = Factory(:ride_offer, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 03:30:00 pm', :vehicle => '4-Wheeler')
      @ride_offer6 = Factory(:ride_offer, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 04:30:00 pm', :vehicle => '4-Wheeler')
      @ride_offer7 = Factory(:ride_offer, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => '2-Wheeler')
      @ride_offer8 = Factory(:ride_offer, :orig => 'Madhapur', :dest => 'Jubilee Hills Road No 92', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => '4-Wheeler')
      @ride_offer9 = Factory(:ride_offer, :orig => 'Madhapur', :dest => 'Kachiguda Railway Station', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:00:00 pm', :vehicle => '4-Wheeler')
      @ride_offer10 = Factory(:ride_offer, :orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => '4-Wheeler')
      @ride_offer10.offerer.update_attribute(:inactive, true)
    end

    it 'should return results for search criteria 1' do
      params = {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => '4-Wheeler'}
      results = RideOffer.search(params)
      results.should have(3).things
      results.should == [@ride_offer1, @ride_offer2, @ride_offer3]
      results.should_not include [@ride_offer4, @ride_offer5, @ride_offer6, @ride_offer7, @ride_offer8, @ride_offer9, @ride_offer10]
    end

    it 'should return results for search criteria 2' do
      params = {:orig => 'Madhapur', :dest => 'Jubilee Hills Road No 92', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => '4-Wheeler'}
      results = RideOffer.search(params)
      results.should have(1).things
      results.should include @ride_offer8
      results.should_not include [@ride_offer2, @ride_offer3, @ride_offer9, @ride_offer4, @ride_offer5, @ride_offer6, @ride_offer7, @ride_offer1, @ride_offer10]
    end

    it 'should return results for search criteria 3' do
      params = {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => '2-Wheeler'}
      results = RideOffer.search(params)
      results.should have(1).things
      results.should include @ride_offer7
      results.should_not include [@ride_offer2, @ride_offer3, @ride_offer9, @ride_offer4, @ride_offer5, @ride_offer6, @ride_offer8, @ride_offer1, @ride_offer10]
    end

    it 'should not return results for search criteria 1' do
      params = {:orig => 'Miyapur', :dest => 'Kothaguda', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => '2-Wheeler'}
      results = RideOffer.search(params)
      results.should have(0).things
    end

    it 'should not return results for search criteria 2' do
      params = {:orig => 'Madhapur', :dest => 'Miyapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 02:30:00 pm', :vehicle => '4-Wheeler'}
      results = RideOffer.search(params)
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

