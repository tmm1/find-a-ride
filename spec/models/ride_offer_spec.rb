require 'spec_helper'

describe RideOffer do
  describe '#attributes and associations' do
    it { should belong_to(:offerer), :class_name => 'User', :foreign_key => 'user_id' }
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
      @ride_offer1 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => get_date, :start_time => "#{get_date} 01:30:00 pm" ,
        :offerer => @login_user
      })
      @ride_offer2 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => get_date, :start_time => "#{get_date} 01:30:00 pm"
      })
      @ride_offer3 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => get_date, :start_time => "#{get_date} 02:00:00 pm"
      })
      @ride_offer4 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => get_date, :start_time => "#{get_date} 02:30:00 pm"
      })
      @ride_offer5 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => get_date, :start_time => "#{get_date} 03:30:00 pm"
      })
      @ride_offer6 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => get_date, :start_time => "#{get_date} 04:30:00 pm"
      })
      @ride_offer7 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'two_wheeler',
        :start_date => get_date, :start_time => "#{get_date} 01:30:00 pm"
      })
      @ride_offer8 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Jubilee Hills Road No 1', :vehicle => 'four_wheeler',
        :start_date => get_date, :start_time => "#{get_date} 01:30:00 pm"
      })
      @ride_offer9 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kachiguda Railway Station', :vehicle => 'four_wheeler',
        :start_date => get_date, :start_time => "#{get_date} 01:00:00 pm"
      })
      @ride_offer10 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => get_date, :start_time => "#{get_date} 01:30:00 pm"
      })
      @ride_offer11 = Factory(:ride_offer, {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'two_wheeler',
        :start_date => get_date, :start_time => "#{get_date} 04:30:00 pm"
      })
      @ride_offer10.offerer.update_attribute(:inactive, true)

      @ride_offer12_params = {
        :orig => 'Madhapur', :dest => 'Kondapur', :vehicle => 'four_wheeler',
        :start_date => (Time.now - 31.minutes).strftime("%d/%b/%Y"), :start_time => (Time.now - 31.minutes).strftime("%d/%b/%Y %r"),
        :user_id => @login_user.id
      }
      @ride_offer12 = Factory.build(:ride_offer, @ride_offer12_params)
      @ride_offer12.save(:validate => false) # to save a past ride
    end

    it 'should return results for search criteria 1' do
      params = {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => get_date, :start_time => "#{get_date} 01:30:00 pm", :vehicle => 'four_wheeler' , :user_id => @login_user.id}
      results = RideOffer.search(params)
      results.should have(2).things
      results.should == [@ride_offer2, @ride_offer3]
      results.should_not include [@ride_offer1, @ride_offer4, @ride_offer5, @ride_offer6, @ride_offer7, @ride_offer8, @ride_offer9, @ride_offer10]
    end

    it 'should return results for search criteria 2' do
      params = {:orig => 'Madhapur', :dest => 'Jubilee Hills Road No 1', :start_date => get_date, :start_time => "#{get_date} 01:30:00 pm", :vehicle => 'four_wheeler', :user_id => @login_user.id}
      results = RideOffer.search(params)
      results.should have(1).things
      results.should include @ride_offer8
      results.should_not include [@ride_offer2, @ride_offer3, @ride_offer9, @ride_offer4, @ride_offer5, @ride_offer6, @ride_offer7, @ride_offer1, @ride_offer10]
    end

    it 'should return results for search criteria 3' do
      params = {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => get_date, :start_time => "#{get_date} 01:30:00 pm", :vehicle => 'two_wheeler', :user_id => @login_user.id}
      results = RideOffer.search(params)
      results.should have(1).things
      results.should include @ride_offer7
      results.should_not include [@ride_offer2, @ride_offer3, @ride_offer9, @ride_offer4, @ride_offer5, @ride_offer6, @ride_offer8, @ride_offer1, @ride_offer10]
    end

    it 'should return results for search criteria 4' do
      params = {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => get_date, :start_time => "#{get_date} 04:30:00 pm", :vehicle => 'any', :user_id => @login_user.id}
      results = RideOffer.search(params)
      results.should have(2).things
      results.should include @ride_offer6
      results.should include @ride_offer11
      results.should_not include [@ride_offer2, @ride_offer3, @ride_offer9, @ride_offer4, @ride_offer5, @ride_offer7, @ride_offer8, @ride_offer1, @ride_offer10]
    end

    it 'should not return results for search criteria 1' do
      params = {:orig => 'Miyapur', :dest => 'Kothaguda', :start_date => get_date, :start_time => "#{get_date} 01:30:00 pm", :vehicle => 'two_wheeler', :user_id => @login_user.id}
      results = RideOffer.search(params)
      results.should have(0).things
    end

    it 'should not return results for search criteria 2' do
      params = {:orig => 'Madhapur', :dest => 'Miyapur', :start_date => get_date, :start_time => "#{get_date} 02:30:00 pm", :vehicle => 'four_wheeler', :user_id => @login_user.id}
      results = RideOffer.search(params)
      results.should have(0).things
    end

    it 'should not return results for search criteria 3' do
      results = RideOffer.search(@ride_offer12_params)
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

