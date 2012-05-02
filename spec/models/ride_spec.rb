require 'spec_helper'

describe Ride do

  def get_date(time)
    time.strftime("%d/%m/%Y")
  end

  def get_time(time)
    time.strftime("%d/%m/%Y %r")
  end

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
    
    it { should belong_to(:ride_origin), :class_name => 'Location', :foreign_key => 'origin'}
    it { should belong_to(:ride_destination), :class_name => 'Location', :foreign_key => 'destination'}
    
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
    
    it 'should not allow additional info with greater than 300 chars' do
      ride = Factory.build(:ride)
      ride.notes = 'a'*301
      ride.valid?.should be false
      ride.should have(1).errors_on(:notes)
    end
    
    it 'should not allow past times for ride request on the same day' do
      ride = Factory.build(:ride)
      ride.start_date = Time.now.strftime("%d/%m/%Y")
      ride.start_time = (Time.now.-1.hour).strftime("%I:%M %p")
      ride.valid?.should be false
      ride.errors[:start_time].should include("can't be in the past")
    end    
    
    it 'should assign attributes appropriately for a ride request during creation' do
      ride_request = RideRequest.create({:orig => 'Madhapur', :dest => 'Kondapur', :start_date => get_date(2.days.from_now), :start_time => get_time(2.days.from_now)})
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

  describe "#scopes" do
    it 'default_scope should ignore expired rides' do
      Ride.scoped.where_values.should eql(["rides.expires_on >= '#{Date.today}'"])
    end

    it 'ride offers scope should ignore ride requests' do
      Ride.offers.where_values.should eql(["rides.expires_on >= '#{Date.today}'", "rides.expires_on >= '#{Date.today}'", "type = 'RideOffer'"])
    end
    
    it "should return ride offers in the ride time order" do
      Ride.offers.order_values.should == ["ride_time"]
    end    
  end

  describe "#filter" do  

    before(:all) do
     @login_user = Factory(:user)
     @other_user = Factory(:user)
      Ride.destroy_all
      @ride_offer1 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => 0.day.from_now.strftime("%d/%b/%Y"), :start_time => "11:59:50 pm",
        :offerer => @other_user
      })
      @ride_offer2 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => Time.now.tomorrow.strftime("%d/%b/%Y"), :start_time => "11:00:00 pm",
        :offerer => @other_user
      })
      @ride_offer3 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => 2.days.from_now.strftime("%d/%b/%Y"), :start_time => "02:00:00 pm",
        :offerer => @other_user
      })
      @ride_offer4 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => 7.days.from_now.strftime("%d/%b/%Y"), :start_time => "02:30:00 pm",
        :offerer => @other_user
      })
      @ride_offer5 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => 14.days.from_now.strftime("%d/%b/%Y"), :start_time => "03:30:00 pm",
        :offerer => @other_user
      })
      @ride_offer6 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => 0.day.from_now.strftime("%d/%b/%Y"), :start_time => "11:59:59 pm",
        :offerer => @other_user
      })
      @ride_offer7 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'two_wheeler',
        :start_date => 7.days.from_now.strftime("%d/%b/%Y"), :start_time => "01:30:00 pm",
        :offerer => @other_user
      })
      @ride_offer8 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Jubilee Hills Road No 1', :vehicle => 'four_wheeler',
        :start_date => 2.days.from_now.strftime("%d/%b/%Y"), :start_time => "01:30:00 pm",
        :offerer => @other_user
      })
      @ride_offer9 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kachiguda Railway Station', :vehicle => 'four_wheeler',
        :start_date => 2.days.from_now.strftime("%d/%b/%Y"), :start_time => "01:00:00 pm",
        :offerer => @other_user
      })
      @ride_offer10 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => 14.days.from_now.strftime("%d/%b/%Y"), :start_time => "01:30:00 pm",
        :offerer => @other_user
      })
      @ride_offer11 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Jubilee Hills Road No 1', :vehicle => 'two_wheeler',
        :start_date => Time.now.tomorrow.strftime("%d/%b/%Y"), :start_time => "11:30:00 pm",
        :offerer => @login_user
      })
    end


    it 'should return results for filter criteria 1' do
      params = {:orig => '', :dest => '', :ride_time => "today",  :vehicle => 'any', :user_id => @login_user.id}
      results = Ride.filter(params)
      results.should have(2).things
      results.should == [@ride_offer1, @ride_offer6]
      results.should_not include [@ride_offer2,@ride_offer3,@ride_offer4, @ride_offer5, @ride_offer7, @ride_offer8, @ride_offer9, @ride_offer10]
    end 
    
    it 'should return results for filter criteria 2' do
      params = {:orig => '', :dest => '', :ride_time => "tomorrow",  :vehicle => 'any', :user_id => @login_user.id}
      results = Ride.filter(params)
      results.should have(1).things
      results.should == [@ride_offer2]
      results.should_not include [@ride_offer1, @ride_offer3, @ride_offer4, @ride_offer5, @ride_offer6, @ride_offer7, @ride_offer8, @ride_offer9, @ride_offer10]
    end

    it 'should return results for filter criteria 3' do
      params = {:orig => '', :dest => '', :ride_time => 2.days.from_now.end_of_day(),  :vehicle => 'any', :user_id => @login_user.id}
      results = Ride.filter(params)
      results.should have(6).things      
    end

     it 'should return results for filter criteria 4' do
      params = {:orig => '', :dest => 'Kachiguda Railway Station', :ride_time => 2.days.from_now.end_of_day(),  :vehicle => 'any', :user_id => @login_user.id}
      results = Ride.filter(params)
      results.should have(1).things
    end

     it 'should return results for filter criteria 5' do
      params = {:orig => 'Madhapur', :dest => 'Jubilee Hills Road No 1', :ride_time => "tomorrow",  :vehicle => 'any', :user_id => @login_user.id}
      results = Ride.filter(params)
      results.should have(0).things
    end

  end

  describe "#duplicate validation for ride request" do
    before(:each) do
      Ride.destroy_all
    end

    it "should fail with the duplicate error" do
      ride_request1 = RideRequest.create({
        :orig => 'Madhapur', :dest => 'Kondapur', :type=>"RideRequest", :vehicle => "two_wheeler",
        :start_date => get_date(2.days.from_now), :start_time => get_time(2.days.from_now)
      })
      ride_request2 = RideRequest.new({
        :orig => 'Madhapur', :dest => 'Kondapur', :type=>"RideRequest", :vehicle => "two_wheeler",
        :start_date => get_date(2.days.from_now), :start_time => get_time(2.days.from_now)
      })
      ride_request2.should_not be_valid
      ride_request2.errors[:base].should include ("Oops. You already put in one with similar criteria!")
    end

    it "should successfully create a ride request" do
      ride_request1 = RideRequest.create({
        :orig => 'Madhapur', :dest => 'Begumpet', :type=>"RideRequest",
        :start_date => get_date(2.days.from_now), :start_time => get_time(2.days.from_now)
      })
      ride_request2 = RideRequest.new({
        :orig => 'Madhapur', :dest => 'Addagutta', :type=>"RideRequest",
        :start_date => get_date(2.days.from_now), :start_time => get_time(2.days.from_now)
      })
      ride_request2.should be_valid
      ride_request2.errors.full_messages.should eql([])
    end


    it "should successfully create a ride request if vehicle type is different" do
       ride_request1 = RideRequest.create({
        :orig => 'Madhapur', :dest => 'Kondapur', :type=>"RideRequest", :vehicle => "two_wheeler",
        :start_date => get_date(2.days.from_now), :start_time => get_time(2.days.from_now)
      })
      ride_request2 = RideRequest.new({
        :orig => 'Madhapur', :dest => 'Kondapur', :type=>"RideRequest", :vehicle => "four_wheeler",
        :start_date => get_date(2.days.from_now), :start_time => get_time(2.days.from_now)
      })
      ride_request2.should be_valid
      ride_request2.errors.full_messages.should eql([])
    end
  end

  describe "#duplicate validation for ride offer" do
    before(:each) do
      Ride.destroy_all
    end
    it "should fail with the duplicate error" do
      ride_offer1 = RideOffer.create({
        :orig => 'Madhapur', :dest => 'Kondapur', :type=>"RideOffer",:vehicle => "two_wheeler",
        :start_date => get_date(2.days.from_now), :start_time => get_time(2.days.from_now)
      })
      ride_offer2 = RideOffer.create({
        :orig => 'Madhapur', :dest => 'Kondapur', :type=>"RideOffer",:vehicle => "two_wheeler",
        :start_date => get_date(2.days.from_now), :start_time => get_time(2.days.from_now)
      })
      ride_offer2.should_not be_valid
      ride_offer2.errors[:base].should include ("Oops. You already put in one with similar criteria!")
    end

    it "should successfully create a ride offer" do
      ride_offer1 = RideOffer.create({
        :orig => 'Madhapur', :dest => 'Begumpet', :type=>"RideOffer",
        :start_date => get_date(2.days.from_now), :start_time => get_time(2.days.from_now)
      })
      ride_offer2 = RideOffer.new({
        :orig => 'Madhapur', :dest => 'Addagutta', :type=>"RideOffer",
        :start_date => get_date(2.days.from_now), :start_time => get_time(2.days.from_now)
      })
      ride_offer2.should be_valid
      ride_offer2.errors.full_messages.should eql([])
    end

    it "should successfully create a ride offer if vehicle type is different" do
      ride_offer1 = RideOffer.create({
        :orig => 'Madhapur', :dest => 'Begumpet', :type=>"RideOffer",:vehicle => "four_wheeler",
        :start_date => get_date(2.days.from_now), :start_time => get_time(2.days.from_now)
      })
      ride_offer2 = RideOffer.new({
        :orig => 'Madhapur', :dest => 'Begumpet', :type=>"RideOffer",:vehicle => "two_wheeler",
        :start_date => get_date(2.days.from_now), :start_time => get_time(2.days.from_now)
      })
      ride_offer2.should be_valid
      ride_offer2.errors.full_messages.should eql([])
    end
  end
  
  describe "#type methods" do
    it 'should return true for RideRequest type' do
      ride = Factory(:ride_request)
      ride.request?.should be true
      ride.offer?.should be false
    end
    
    it 'should return true for RideOffer type' do
      ride = Factory(:ride_offer)
      ride.offer?.should be true
      ride.request?.should be false
    end
  end

  describe "#deletable? check" do
    before(:all) do
      @contacter = Factory(:user)
    end

    it "should return true for a past ride with no hook_ups" do
      ride = Factory(:ride_offer, :user_id => @contacter.id, :start_date => get_date(2.days.ago), :start_date => "#{get_date(2.days.ago)} 01:30:00")
      ride.deletable?.should be_true
    end

    it "should return true for a future ride with no hook_ups" do
      ride = Factory(:ride_offer, :user_id => @contacter.id, :start_date => get_date(2.days.from_now), :start_date => "#{get_date(2.days.from_now)} 02:30:00")
      ride.deletable?.should be_true
    end

    it "should return true for a past ride with all closed hook_ups" do
      ride = Factory(:ride_request, :user_id => @contacter.id, :start_date => get_date(2.days.ago), :start_date => "#{get_date(2.days.ago)} 02:30:00")
      hook_up1 = Factory(:hook_up, :contacter => @contacter, :hookable => ride, :hookable_type => "RideRequest")
      hook_up2 = Factory(:hook_up, :contacter => @contacter, :hookable => ride, :hookable_type => "RideRequest")
      hook_up1.close
      hook_up2.close
      ride.deletable?.should be_true
    end

    it "should return false for a past ride with an unclosed hook_up" do
      ride = Factory(:ride_request, :user_id => @contacter.id, :start_date => get_date(2.days.ago), :start_date => "#{get_date(2.days.ago)} 02:30:00")
      hook_up1 = Factory(:hook_up, :contacter => @contacter, :hookable => ride, :hookable_type => "RideRequest")
      hook_up2 = Factory(:hook_up, :contacter => @contacter, :hookable => ride, :hookable_type => "RideRequest")
      hook_up1.request
      hook_up2.close
      ride.deletable?.should be_false
    end
  end

  describe "#humanize_type" do
    it "should return correct humanized type" do
      ride_request, ride_offer = Factory(:ride_request), Factory(:ride_offer)
      ride_request.humanize_type.should eql("ride request")
      ride_offer.humanize_type.should eql("ride offer")
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
#  payment     :string(255)
#  notes       :string(3000)
#

