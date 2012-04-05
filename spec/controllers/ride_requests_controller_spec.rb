require 'spec_helper'

describe RideRequestsController do
  render_views
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
      ride_req.ride_time.should == "#{params[:start_date]} #{params[:start_time]} +0530".to_datetime
      ride_req.vehicle.should == 'four_wheeler'
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

    it "should fail creating a  duplicate record" do
      sign_in @login_user
      params1 = Factory.attributes_for(:ride_request)
      post 'create', :ride_request => params1
      params2 = Factory.attributes_for(:ride_request)
      post 'create', :ride_request => params2
      ride_request = assigns(:ride_request)
      ride_request.errors.first.should include("Oops. You already put in one with similar criteria!")
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
      get 'search', {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => 'four_wheeler'}
      response.should be_success
      response.should render_template(:results)
      assigns(:paginated_results).should have(2).things
    end
    
    it "should render the search page with with no results" do   
      RideRequest.stub!(:search).and_return(RideRequest.where(:origin => 'nowhere'))
      sign_in @login_user
      get 'search', {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => 'four_wheeler'}
      response.should be_success
      response.should render_template(:results)
      assigns(:paginated_results).should have(0).things
    end
  end

  describe "for inactive users" do
    before(:all) do
      @inactive_user = Factory(:user, :inactive => true)
      @inactive_user.confirm!
    end

    [
      {:action => :new,    :method => :get},
      {:action => :create, :method => :post, :args => {:ride_request  => Factory.attributes_for(:ride_request)}},
      {:action => :search, :method => :post, :args => {:search_params => Factory.attributes_for(:ride)}}
    ].each do |method|
      it "##{method[:action]} should be redirected to HomeController#inactive" do
        sign_in @inactive_user
        send method[:method], method[:action], method[:args]
        response.should redirect_to(inactive_home_index_path)
      end
    end
  end
end
