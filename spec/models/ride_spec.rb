require 'spec_helper'

describe Ride do
  describe "#attributes and methods" do
    it { should validate_presence_of(:orig) }
    it { should validate_presence_of(:dest) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:start_time) }
     
    it { should allow_value('Madhapur').for(:orig) }
    it { should allow_value('madhapur').for(:orig) }
    
    it { should allow_value('Kondapur').for(:dest) }
    it { should allow_value('kOndApur').for(:dest) }
    
    it { should allow_value('1230').for(:start_time)}
    it { should allow_value('2012-03-21 01:30:00').for(:start_time)}
    
    it 'should allow only valid values for start time' do
      ride = Factory.build(:ride)
      ride.start_time = 'blahblah'
      ride.valid?.should be false
      ride.should have(1).errors_on(:start_time)
      ride.errors[:start_time].should include('is not valid')
    end
    
    it 'should allow only valid values for origin' do
      ride = Factory.build(:ride)
      ride.orig = 'unknown'
      ride.valid?.should be false
      ride.should have(1).errors_on(:orig)
      ride.errors[:orig].should include('is not valid')
    end
    
    it 'should allow only valid values for destination' do
      ride = Factory.build(:ride)
      ride.dest = 'unknown'
      ride.valid?.should be false
      ride.should have(1).errors_on(:dest)
      ride.errors[:dest].should include('is not valid')
    end
    
    it 'should assign attributes appropriately for a ride request during creation' do
      ride_request = RideRequest.create({:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '10/12/2012', :start_time => '10/12/2012 01:30:00'})
      ride_request.ride_origin.should == Location.find_by_name('Madhapur')
      ride_request.ride_destination.should == Location.find_by_name('Kondapur')
      ride_request.ride_time.should == Helper.to_datetime(ride_request.start_date, ride_request.start_time)
    end
    
    it 'should assign attributes appropriately for a ride offer during creation' do
      ride_offer = RideOffer.create({:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '10/12/2012', :start_time => '10/12/2012 01:30:00'})
      ride_offer.ride_origin.should == Location.find_by_name('Madhapur')
      ride_offer.ride_destination.should == Location.find_by_name('Kondapur')
      ride_offer.ride_time.should == Helper.to_datetime(ride_offer.start_date, ride_offer.start_time)
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

