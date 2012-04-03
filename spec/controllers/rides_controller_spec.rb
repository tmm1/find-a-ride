require 'spec_helper'

describe RidesController do
  render_views
  include Devise::TestHelpers
  before(:all) do
    @login_user = Factory(:user)
    @login_user.confirm!
  end

  describe "#new" do
    it "should render new" do     
      sign_in @login_user
      get 'new'
      response.should be_success
      response.should render_template(:new)
      assigns(:ride_request).should_not be nil
      assigns(:ride_offer).should_not be nil
    end
  end

  describe "#index" do
    it "should render index" do     
      sign_in @login_user
      get 'index'
      response.should be_success
      response.should render_template(:index)
      assigns(:ride).should_not be nil
    end
  end
  
  describe '#search' do
    it "should perform search for valid criteria" do
      sign_in @login_user
      search_params = Factory.attributes_for(:ride)
      post 'search', {:ride => search_params}
      response.should redirect_to(search_ride_offers_path(search_params))
      assigns(:ride).should be_valid
    end
    
    it "should not perform search for invalid criteria" do
      sign_in @login_user
      search_params = Factory.attributes_for(:ride)
      search_params[:orig] = nil
      search_params[:dest] = nil
      post 'search', {:ride => search_params}
      response.should be_success
      response.should render_template(:index)
      assigns(:ride).should_not be_valid
    end
  end
end
