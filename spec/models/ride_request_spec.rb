require 'spec_helper'

describe RideRequest do
  
  describe '#attributes and associations' do
    it { should belong_to(:requestor), :class_name => 'User', :foreign_key => 'user_id' }
    it { should have_many(:hook_ups), :as => :hookable}
  end

  describe "#search" do
    def get_date
      @ride_date ||= 2.days.from_now
      @ride_date.strftime("%d/%b/%Y")
    end

    before(:all) do
      @login_user = Factory(:user)
      Ride.destroy_all
      @ride_request1 = Factory(:ride_request, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => "#{get_date}", :start_time => "#{get_date} 01:30:00 pm",
        :requestor => @login_user
      })
      @ride_request2 = Factory(:ride_request, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => "#{get_date}", :start_time => "#{get_date} 01:30:00 pm"
      })
      @ride_request3 = Factory(:ride_request, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => "#{get_date}", :start_time => "#{get_date} 02:00:00 pm"
      })
      @ride_request4 = Factory(:ride_request, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => "#{get_date}", :start_time => "#{get_date} 02:30:00 pm"
      })
      @ride_request5 = Factory(:ride_request, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => "#{get_date}", :start_time => "#{get_date} 03:30:00 pm"
      })
      @ride_request6 = Factory(:ride_request, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => "#{get_date}", :start_time => "#{get_date} 04:30:00 pm"
      })
      @ride_request7 = Factory(:ride_request, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'two_wheeler',
        :start_date => "#{get_date}", :start_time => "#{get_date} 01:30:00 pm"
      })
      @ride_request8 = Factory(:ride_request, {
        :orig => 'Madhapur', :dest => 'Miyapur', :vehicle => 'four_wheeler',
        :start_date => "#{get_date}", :start_time => "#{get_date} 01:30:00 pm"
      })
      @ride_request9 = Factory(:ride_request, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => "#{get_date}", :start_time => "#{get_date} 01:00:00 pm"
      })
      @ride_request10 = Factory(:ride_request, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => "#{get_date}", :start_time => "#{get_date} 01:00:00 pm"
      })
      @ride_request11 = Factory(:ride_request, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'any',
        :start_date => "#{get_date}", :start_time => "#{get_date} 04:30:00 pm"
      })
      @ride_request10.requestor.update_attribute(:inactive, true)

      @ride_request12_params = {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => (Time.now - 31.minutes).strftime("%d/%b/%Y"), :start_time => (Time.now - 31.minutes).strftime("%d/%b/%Y %r"),
        :user_id => @login_user.id
      }
      @ride_request12 = Factory.build(:ride_request, @ride_request12_params)
      @ride_request12.save(:validate => false) # to save a past ride
    end

    it 'should return results for search criteria 1' do
      params = {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => "#{get_date}", :start_time => "#{get_date} 01:30:00 pm", :vehicle => 'four_wheeler', :user_id => @login_user.id}
      results = RideRequest.search(params)
      results.should have(3).things
      results.should == [@ride_request9, @ride_request2, @ride_request3]
      results.should_not include [@ride_request1,@ride_request4, @ride_request5, @ride_request6, @ride_request7, @ride_request8, @ride_request10, @ride_request11]
    end

    it 'should return results for search criteria 2' do
      params = {:orig => 'Madhapur', :dest => 'Miyapur', :start_date => "#{get_date}", :start_time => "#{get_date} 01:30:00 pm", :vehicle => 'four_wheeler', :user_id => @login_user.id}
      results = RideRequest.search(params)
      results.should have(1).things
      results.should include @ride_request8
      results.should_not include [@ride_request2, @ride_request3, @ride_request9, @ride_request4, @ride_request5, @ride_request6, @ride_request7, @ride_request1, @ride_request10, @ride_request11]
    end

    it 'should return results for search criteria 3' do
      params = {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => "#{get_date}", :start_time => "#{get_date} 01:30:00 pm", :vehicle => 'two_wheeler', :user_id => @login_user.id}
      results = RideRequest.search(params)
      results.should have(1).things
      results.should include @ride_request7
      results.should_not include [@ride_request2, @ride_request3, @ride_request9, @ride_request4, @ride_request5, @ride_request6, @ride_request8, @ride_request1, @ride_request10, @ride_request11]
    end
    
    it 'should return results for search criteria 4' do
      params = {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => "#{get_date}", :start_time => "#{get_date} 04:30:00 pm", :vehicle => 'four_wheeler', :user_id => @login_user.id}
      results = RideRequest.search(params)
      results.should have(2).things
      results.should == [@ride_request6, @ride_request11]
      results.should_not include [@ride_request2, @ride_request3, @ride_request9, @ride_request4, @ride_request5, @ride_request7, @ride_request8, @ride_request1, @ride_request10]
    end

    it 'should not return results for search criteria 1' do
      params = {:orig => 'Miyapur', :dest => 'Kothaguda', :start_date => "#{get_date}", :start_time => "#{get_date} 01:30:00 pm", :vehicle => 'two_wheeler', :user_id => @login_user.id}
      results = RideRequest.search(params)
      results.should have(0).things
    end

    it 'should not return results for search criteria 2' do
      params = {:orig => 'Madhapur', :dest => 'Miyapur', :start_date => "#{get_date}", :start_time => "#{get_date} 02:30:00 pm", :vehicle => 'four_wheeler', :user_id => @login_user.id}
      results = RideRequest.search(params)
      results.should have(0).things
    end

    it 'should not return results for search criteria 12' do
      results = RideRequest.search(@ride_request12_params)
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
#  payment     :string(255)
#  notes       :string(3000)
#

