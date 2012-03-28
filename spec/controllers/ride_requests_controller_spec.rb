require 'spec_helper'

describe RideRequestsController do
  include Devise::TestHelpers
  before(:all) do
    @login_user = Factory(:user)
    @login_user.confirm!
  end

  describe "#new" do
    it 'should render new' do
      sign_in @login_user
      get :new
      response.should be_success
      response.should render_template(:new)
    end
  end

  describe "#create" do
    it "should successfully create a new ride request" do
      sign_in @login_user
      params = Factory.attributes_for(:ride_request)
      post 'create', :ride_request => params
      response.should redirect_to(search_ride_offers_path(params))
      ride_req = assigns(:ride_request)
      ride_req.should_not be_nil
      ride_req.ride_origin.should == Location.find_by_name(params[:orig])
      ride_req.ride_destination.should == Location.find_by_name(params[:dest])
      ride_req.ride_time.should == "#{params[:start_date]} #{params[:start_time]}".to_datetime
      ride_req.vehicle.should == '4-Wheeler'
    end
    
    it "should fail creating an invalid ride request" do
      sign_in @login_user
      params = Factory.attributes_for(:ride_request)
      params[:orig] = 'unknown'
      params[:start_time] = 'blah'
      post 'create', :ride_request => params
      response.should be_success
      response.should render_template(:new)
      ride_req = assigns(:ride_request)
      ride_req.should_not be_nil
      ride_req.valid?.should be false
    end
  end
  
  describe "#search" do
    before(:all) do
      RideRequest.destroy_all
      Factory(:ride_request)
      Factory(:ride_request)
    end
    
    it "should render the search page with results" do   
      RideRequest.stub!(:search).and_return(RideRequest.limit(2))
      sign_in @login_user
      get 'search', {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => '4-Wheeler'}
      response.should be_success
      response.should render_template(:results)
      assigns(:paginated_results).should have(2).things
    end
    
    it "should render the search page with with no results" do   
      RideRequest.stub!(:search).and_return(RideRequest.where(:origin => 'nowhere'))
      sign_in @login_user
      get 'search', {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => '4-Wheeler'}
      response.should be_success
      response.should render_template(:results)
      assigns(:paginated_results).should have(0).things
    end
  end
end