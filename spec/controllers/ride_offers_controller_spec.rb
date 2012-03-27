require 'spec_helper'

describe RideOffersController do
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
      response.should redirect_to(rides_path)
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
end
