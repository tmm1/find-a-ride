require 'spec_helper'

describe SearchController do
  describe "#search rides for drivers" do
    before(:all) do
      User.stub!(:find_matches_for_drivers).and_return([Factory(:user), Factory(:user)])
    end
    it "should return matches for drivers" do
      get 'search_rides', {:origin => 'origin1', :dest => 'dest1', :matcher => 'drivers'}
      response.should be_success
      response.should render_template(:search_results)
      assigns(:results).size.should == 2
    end
  end
  describe "#search rides for riders" do
    before(:all) do
      User.stub!(:find_matches_for_riders).and_return([Factory(:user), Factory(:user)])
    end
    it "should return matches for riders" do
      get 'search_rides', {:origin => 'origin1', :dest => 'dest1', :matcher => 'riders'}
      response.should be_success
      response.should render_template(:search_results)
      assigns(:results).size.should == 2
    end
  end
end
