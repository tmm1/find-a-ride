require 'spec_helper'

describe RidesController do
  describe "#search rides for drivers" do
    before(:all) do
      User.destroy_all
      3.times { Factory(:user) }
    end
    
    it "should return matches for drivers" do
      User.stub!(:find_matches_for_drivers).and_return(User.where(:origin => 'Madhapur'))
      get 'search', {:origin => 'origin1', :dest => 'dest1', :matcher => 'drivers'}
      response.should be_success
      response.should render_template(:search_results)
      assigns(:paginated_results).size.should == 3
    end
    
    it "should not return matches for drivers" do
      User.stub!(:find_matches_for_drivers).and_return(User.where(:origin => 'nowhere'))
      get 'search', {:origin => 'origin1', :dest => 'dest1', :matcher => 'drivers'}
      response.should be_success
      response.should render_template(:search_results)
      assigns(:paginated_results).empty?.should == true
    end
  end
  
  describe "#search rides for riders" do
    before(:all) do
      User.destroy_all
      3.times { Factory(:user) }
    end
    
    it "should return matches for riders" do
      User.stub!(:find_matches_for_riders).and_return(User.where(:origin => 'Madhapur'))
      get 'search', {:origin => 'origin1', :dest => 'dest1', :matcher => 'riders'}
      response.should be_success
      response.should render_template(:search_results)
      assigns(:paginated_results).size.should == 3
    end
  end
  
  describe "#contact for rides" do
    before(:each) do
      @user_1 = Factory(:user)
      @user_2 = Factory(:user)
      Ride.stub!(:create_ride).and_return(true)
    end
    
    it "should successfully contact and create a ride for a user looking for drivers" do
      post :contact, :params => {:contactee_id => @user_1.id, :contactor_id => @user_2.id, :user_info => nil, :message => 'Hi there!', :matcher => 'drivers'}
      response.should be_success
      response.body.should == 'Your message was successfully sent. Thank you!'
    end
    
    it "should successfully contact and create a ride for an anonymous user looking for riders" do
      post :contact, :params => {:contactee_id => @user_1.id, :contactor_id => nil, :user_info => {:email => 'ks@test.com', :name => 'Kraken John', :phone => '982201112'}, :message => 'Hi there!', :matcher => 'riders'}
      response.should be_success
      response.body.should == 'Your message was successfully sent. Thank you!'
    end
  end
end
