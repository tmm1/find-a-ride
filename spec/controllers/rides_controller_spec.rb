require 'spec_helper'

describe RidesController do
  render_views
  include Devise::TestHelpers
  before(:all) do
    @login_user = Factory(:user)
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
      response.should redirect_to(search_ride_offers_path(search_params.merge({:from => :search})))
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

  describe "#inactive users" do
    before(:all) do
      @inactive_user = Factory(:user, :inactive => true)
    end

    [
      {:action => :new,    :method => :get},
      {:action => :index,  :method => :get},
      {:action => :search, :method => :post, :args => {:search_params => Factory.attributes_for(:ride)}}
    ].each do |method|
      it "#{method[:action]} should redirect to inactive page" do
        sign_in @inactive_user
        send method[:method], method[:action], method[:args]
        response.should redirect_to(inactive_home_index_path)
      end
    end
  end
end
