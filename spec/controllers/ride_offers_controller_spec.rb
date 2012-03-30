require 'spec_helper'

describe RideOffersController do
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
    it "should successfully create a new ride offer" do
      sign_in @login_user
      params = Factory.attributes_for(:ride_offer)
      post 'create', :ride_offer => params
      response.should redirect_to(search_ride_requests_path(params))
      ride_offer = assigns(:ride_offer)
      ride_offer.should_not be_nil
      ride_offer.ride_origin.should == Location.find_by_name(params[:orig])
      ride_offer.ride_destination.should == Location.find_by_name(params[:dest])
      ride_offer.ride_time.should == "#{params[:start_date]} #{params[:start_time]}".to_datetime
      ride_offer.vehicle.should == '2-Wheeler'
    end

    it "should fail creating an invalid ride offer" do
      sign_in @login_user
      params = Factory.attributes_for(:ride_offer)
      params[:orig] = 'unknown'
      params[:start_time] = 'blah'
      post 'create', :ride_offer => params
      response.should be_success
      response.should render_template(:new)
      ride_offer = assigns(:ride_offer)
      ride_offer.should_not be_nil
      ride_offer.valid?.should be false
    end
  end

  describe "#search" do
    before(:all) do
      RideOffer.destroy_all
      Factory(:ride_offer)
      Factory(:ride_offer)
    end

    it "should render the search page with results" do   
      RideOffer.stub!(:search).and_return(RideOffer.limit(2))
      sign_in @login_user
      get 'search', {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => '4-Wheeler'}
      response.should be_success
      response.should render_template(:results)
      assigns(:paginated_results).should have(2).things
    end

    it "should render the search page with with no results" do   
      RideOffer.stub!(:search).and_return(RideOffer.where(:origin => 'nowhere'))
      sign_in @login_user
      get 'search', {:orig => 'Madhapur', :dest => 'Kondapur', :start_date => '12/Jan/2012', :start_time => '12/Jan/2012 01:30:00 pm', :vehicle => '4-Wheeler'}
      response.should be_success
      response.should render_template(:results)
      assigns(:paginated_results).should have(0).things
    end
  end
end
