require 'spec_helper'

describe Ride do
  describe '#attributes and methods' do
    before(:all) do
      @ride = Factory(:ride)
    end
    it "should return humanized user info hash" do
      @ride.user_info = {:name => 'Mahi Dhoni', :email => 'msd@india.com', :phone => '0012201101'}
      @ride.humanized_user_info.should == {"name" => 'Mahi Dhoni', "email" => 'msd@india.com', "phone" => '0012201101'}
    end
  end
  
  describe '#create_ride' do
    before(:all) do
      @user_1 = Factory(:user)
      @user_2 = Factory(:user)
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
    end
    
    before(:each) do
      ActionMailer::Base.deliveries.clear
    end
    
    it 'should create ride for user looking for drivers' do
      ride_params = {:contactee_id => @user_1.id, :contactor_id => @user_2.id, :user_info => nil, :message => 'Hi there!', :matcher => 'drivers'}
      ride_created = Ride.create_ride(ride_params)
      ride_created.should_not be_nil
      ride_created.offerer.should == @user_1
      ride_created.sharer.should == @user_2
      ride_created.user_info.should be_nil
      ActionMailer::Base.deliveries.size.should == 1
    end
  
    it 'should create ride for user looking for riders' do
      ride_params = {:contactee_id => @user_1.id, :contactor_id => @user_2.id, :user_info => nil, :message => 'Hi there!', :matcher => 'riders'}
      ride_created = Ride.create_ride(ride_params)
      ride_created.should_not be_nil
      ride_created.offerer.should == @user_2
      ride_created.sharer.should == @user_1
      ride_created.user_info.should be_nil
      ActionMailer::Base.deliveries.size.should == 1
    end
    
    it 'should create ride for anonymous user looking for drivers' do
      ride_params = {:contactee_id => @user_1.id, :contactor_id => nil, :user_info => {:email => 'ks@test.com', :name => 'Kraken John', :phone => '982201112'}, :message => 'Hi there!', :matcher => 'drivers'}
      ride_created = Ride.create_ride(ride_params)
      ride_created.should_not be_nil
      ride_created.sharer.should be_nil
      ride_created.offerer.should == @user_1
      ride_created.user_info.should == ride_params[:user_info]
      ActionMailer::Base.deliveries.size.should == 1
    end
    
    it 'should create ride for anonymous user looking for riders' do
      ride_params = {:contactee_id => @user_2.id, :contactor_id => nil, :user_info => {:email => 'ks@test.com', :name => 'Kraken John', :phone => '982201112'}, :message => 'Hi there!', :matcher => 'riders'}
      ride_created = Ride.create_ride(ride_params)
      ride_created.should_not be_nil
      ride_created.offerer.should be_nil
      ride_created.sharer.should == @user_2
      ride_created.user_info.should == ride_params[:user_info]
      ActionMailer::Base.deliveries.size.should == 1
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

