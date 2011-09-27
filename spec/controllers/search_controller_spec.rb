require 'spec_helper'

describe SearchController do
  before(:all) do
    User.destroy_all
    3.times { Factory(:user) }
  end
  describe "#search rides for drivers" do
    it "should return matches for drivers" do
      User.stub!(:find_matches_for_drivers).and_return(User.where(:origin => 'Madhapur'))
      get 'search_rides', {:origin => 'origin1', :dest => 'dest1', :matcher => 'drivers'}
      response.should be_success
      response.should render_template(:search_results)
      assigns(:paginated_results).size.should == 3
    end
    it "should not return matches for drivers" do
      User.stub!(:find_matches_for_drivers).and_return(User.where(:origin => 'nowhere'))
      get 'search_rides', {:origin => 'origin1', :dest => 'dest1', :matcher => 'drivers'}
      response.should be_success
      response.should render_template(:search_results)
      assigns(:paginated_results).empty?.should == true
    end
  end
  describe "#search rides for riders" do
    it "should return matches for riders" do
      User.stub!(:find_matches_for_riders).and_return(User.where(:origin => 'Madhapur'))
      get 'search_rides', {:origin => 'origin1', :dest => 'dest1', :matcher => 'riders'}
      response.should be_success
      response.should render_template(:search_results)
      assigns(:paginated_results).size.should == 3
    end
  end
end
