require 'spec_helper'

describe Ride do
   describe "#attributes and methods" do
    it { should validate_presence_of(:orig) }
    it { should validate_presence_of(:dest) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:start_time) }

    it { should_not allow_value('teteste').for(:start_time) }
    it { should allow_value('1230').for(:start_time)}
   

    before(:each) do
      hyd = Factory(:city)
      mad = Factory(:location, :name => 'Madhapur', :city => hyd)
      kon = Factory(:location, :name => 'Kondapur', :city => hyd)
      miy = Factory(:location, :name => 'Miyapur', :city => hyd)
      @ride_request = Factory(:ride, :orig => mad.name, :dest => kon.name, :start_date =>"2012-03-21" , :start_time => "01:30:00",
                  :vehicle   =>  "2-Wheeler",
                  :user_id => Factory(:user).id,
                  :type =>        "RideRequest" )
    end


    it "should save a valid ride" do
      @ride_request.ride_time.should == '2012-03-21 01:30:00'
      @ride_request.save.should be true
    end

    it "should fail start time validation" do
       @ride_request.start_time  = ""
       @ride_request.save.should be false
       @ride_request.errors.to_a.should include("Start time can't be blank", "Start time must be a valid time")
    end

    it "should fail orig validation" do
       @ride_request.orig  = ""
       @ride_request.save.should be false
       @ride_request.errors.to_a.should include("Orig can't be blank")
    end

    it "should fail dest validation" do
       @ride_request.dest  = ""
       @ride_request.save.should be false
       @ride_request.errors.to_a.should include("Dest can't be blank")
    end

    it "should fail start date validation" do
       @ride_request.start_date  = ""
       @ride_request.save.should be false
       @ride_request.errors.to_a.should include("Start date can't be blank")
    end
  end

  describe "ride offer" do
    before(:each) do
      hyd = Factory(:city)
      mad = Factory(:location, :name => 'Madhapur', :city => hyd)
      kon = Factory(:location, :name => 'Kondapur', :city => hyd)
      @ride_offer = Factory(:ride, :orig => kon.name, :dest => mad.name, :start_date =>"2012-03-21" , :start_time => "01:30:00",
                  :vehicle   =>  "2-Wheeler",
                  :user_id => Factory(:user).id,
                  :type =>        "RideOffer" )
    end
    
    it "should save a valid ride" do
      @ride_offer.ride_time.should == '2012-03-21 01:30:00'
      @ride_offer.save.should be true
    end

    it "should fail start time validation" do
       @ride_offer.start_time  = ""
       @ride_offer.save.should be false
       @ride_offer.errors.to_a.should include("Start time can't be blank", "Start time must be a valid time")
    end

    it "should fail orig validation" do
       @ride_offer.orig  = ""
       @ride_offer.save.should be false
       @ride_offer.errors.to_a.should include("Orig can't be blank")
    end

    it "should fail dest validation" do
       @ride_offer.dest  = ""
       @ride_offer.save.should be false
       @ride_offer.errors.to_a.should include("Dest can't be blank")
    end

    it "should fail start date validation" do
       @ride_offer.start_date  = ""
       @ride_offer.save.should be false
       @ride_offer.errors.to_a.should include("Start date can't be blank")
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

