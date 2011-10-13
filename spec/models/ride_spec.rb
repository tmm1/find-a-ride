require 'spec_helper'

describe Ride do
  describe '#create_ride' do
    before(:all) do
      @user_1 = Factory(:user)
      @user_2 = Factory(:user)
    end
    
    it 'should create ride for user looking for drivers' do
      ride_params = {:contactee_id => @user_1.id, :contactor_id => @user_2.id, :user_info => nil, :message => 'Hi there!', :matcher => 'drivers'}
      ride_created = Ride.create_ride(ride_params)
      ride_created.should_not be_nil
      ride_created.offerer.should == @user_1
      ride_created.sharer.should == @user_2
      ride_created.user_info.should be_nil
    end
  
    it 'should create ride for user looking for riders' do
      ride_params = {:contactee_id => @user_1.id, :contactor_id => @user_2.id, :user_info => nil, :message => 'Hi there!', :matcher => 'riders'}
      ride_created = Ride.create_ride(ride_params)
      ride_created.should_not be_nil
      ride_created.offerer.should == @user_2
      ride_created.sharer.should == @user_1
      ride_created.user_info.should be_nil
    end
    
    it 'should create ride for anonymous user looking for drivers' do
      ride_params = {:contactee_id => @user_1.id, :contactor_id => nil, :user_info => {:email => 'ks@test.com', :name => 'Kraken John', :phone => '982201112'}, :message => 'Hi there!', :matcher => 'drivers'}
      ride_created = Ride.create_ride(ride_params)
      ride_created.should_not be_nil
      ride_created.sharer.should be_nil
      ride_created.offerer.should == @user_1
      ride_created.user_info.should == ride_params[:user_info]
    end
    
    it 'should create ride for anonymous user looking for riders' do
      ride_params = {:contactee_id => @user_2.id, :contactor_id => nil, :user_info => {:email => 'ks@test.com', :name => 'Kraken John', :phone => '982201112'}, :message => 'Hi there!', :matcher => 'riders'}
      ride_created = Ride.create_ride(ride_params)
      ride_created.should_not be_nil
      ride_created.offerer.should be_nil
      ride_created.sharer.should == @user_2
      ride_created.user_info.should == ride_params[:user_info]
    end
  end
end

# == Schema Information
#
# Table name: rides
#
#  id           :integer(4)      not null, primary key
#  offerer_id   :integer(4)
#  sharer_id    :integer(4)
#  user_info    :string(1000)
#  contact_date :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

