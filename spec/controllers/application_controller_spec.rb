require 'spec_helper'

describe ApplicationController do
  render_views
  include Devise::TestHelpers
  before(:all) do
    hyd = Factory(:city)
    chn = Factory(:city, :name => 'Chennai')
    Factory(:location, :name => 'Madhapur', :city => hyd)
    Factory(:location, :name => 'Kondapur', :city => hyd)
    Factory(:location, :name => 'Miyapur', :city => hyd)
  end
  describe "#Location Search" do
    it "should return matched locations" do
      get 'location_search', {:q => 'madhapu', :city => 'Hyderabad'}
      assigns[:result].should_not be nil
      assigns[:result].class.should == Array
      assigns[:result].size.should == 1
      assigns[:result].first.should == "Madhapur"
    end
    it "should return empty array of locations" do
      get 'location_search', {:q => 'xxxx', :city => 'Hyderabad'}, :format => :json
      assigns[:result].class.should == Array
      assigns[:result].first.should == nil
    end
    it "should rewrite the search value before search" do
      get 'location_search', {:q => 'MadHap', :city => 'Hyderabad'}, :format => :json
      assigns[:result].should_not be nil
      assigns[:result].class.should == Array
      assigns[:result].size.should == 1
      assigns[:result].first.should == "Madhapur"
    end
  end

  describe "#Geocode City" do
    it "should return hyderabad" do
      get "geocode_city" , {:lat_long =>"(17.385044, 78.486671)"}
      session[:city].should == "Hyderabad"
      response.should be_success
    end

    it "should return Bengaluru" do
      get "geocode_city" , {:lat_long =>"(12.874642,77.827148)"}
      session[:city].should == "Bengaluru"
      response.should be_success
    end

    it "should return New Delhi" do
      get "geocode_city" , {:lat_long =>"(28.48736162133368, 77.14599609375)"}
      session[:city].should == "New Delhi"
      response.should be_success
    end

    it "should return Kanpur" do
      get "geocode_city" , {:lat_long =>"(26.460083,80.266113)"}
      session[:city].should == "Kanpur"
      response.should be_success
    end
  end

  describe "#initialize city" do
    it 'should initialize the city to Hyderabad' do
      post "initialize_city", {:city => 'Hyderabad'}
      response.should be_redirect
      session[:city].should == 'Hyderabad'
      request.flash[:notice].should == 'You have chosen Hyderabad'
    end

    it 'should initialize the city to Chennai' do
      post "initialize_city", {:city => 'Chennai'}
      response.should be_redirect
      session[:city].should == 'Chennai'
      request.flash[:notice].should == 'You have chosen Chennai'
    end

    it 'should initialize the city to Bengaluru' do
      post "initialize_city", {:city => 'Bengaluru'}
      response.should be_redirect
      session[:city].should == 'Bengaluru'
      request.flash[:notice].should == 'You have chosen Bengaluru'
    end
  end

  describe '#selected city' do
    it 'should return hyderabad by default' do
      @controller.selected_city.should == 'Hyderabad'
    end

    it 'should return the session city' do
      session[:city] = 'Chennai'
      @controller.selected_city.should == 'Chennai'
    end

    it 'should return the session city' do
      session[:city] = 'Bengaluru'
      @controller.selected_city.should == 'Bengaluru'
    end
  end

  describe '#admin access' do
    before(:all) do
      @login_user = Factory(:user)
    end
    it 'should render the admin page' do
      sign_in @login_user
      get 'admin'
      response.should be_success
      response.should render_template('home/admin')
    end
    it 'should authorize admin using the correct password' do
      sign_in @login_user
      post 'authorize_admin', {:admin_password => ADMIN_PASSWORD}
      response.should be_redirect
      request.flash[:success].should == 'Thanks for authenticating'
    end
    it 'should authorize admin using the incorrect password' do
      sign_in @login_user
      post 'authorize_admin', {:admin_password => 'd@mn!'}
      response.should be_success
      response.should render_template('home/admin')
      request.flash[:error].should == 'Sorry! That was not the right password'
    end
  end
end
