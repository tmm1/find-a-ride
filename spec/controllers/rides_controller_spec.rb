require 'spec_helper'

describe RidesController do
  include Devise::TestHelpers
  before(:all) do
    @login_user = Factory(:user)
    @login_user.confirm!
  end
  
  describe "#index" do
    it "should render index" do     
      sign_in @login_user
      get 'index'
      response.should be_success
      response.should render_template(:index)
    end
  end
  describe "#request_ride" do
    it "should request ride" do
      sign_in @login_user
      get 'request_ride'
      response.should be_success
      response.should render_template(:request_ride)
    end
  end
  describe "#offer_ride" do
    it "should offer_ride" do
      sign_in @login_user
      get 'offer_ride'
      response.should be_success
      response.should render_template(:offer_ride)
    end
  end
end
