require 'spec_helper'

describe RideOffersController do
   include Devise::TestHelpers
   before(:all) do
     @login_user = Factory(:user)
     @login_user.confirm!
   end

  describe "#create" do
    it "should assign ride details" do
      sign_in @login_user
      params = {"orig"=>"S.R. Nagar", "dest"=>"Safilguda", "start_date"=>"21-03-2012", "start_time"=>"10:30:00 AM", "vehicle"=>"2-Wheeler", "type"=>"RideOffer"}
      post 'create', :ride_offer => params
      response.should redirect_to(rides_path)
    end
    it "should render new" do
      sign_in @login_user
      params = {"orig"=>"S.R. Nagar", "dest"=>"", "start_date"=>"21-03-2012", "start_time"=>"10:30:00 AM", "vehicle"=>"2-Wheeler", "type"=>"RideOffer"}
      post 'create', :ride_offer => params
      response.should render_template(:new)
    end
  end
end
