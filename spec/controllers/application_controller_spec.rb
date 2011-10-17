require 'spec_helper'

describe ApplicationController do
  describe "#Location Search" do
    it "should return matched locations" do
      get 'location_search', {:q => 'madh', :city => 'Hyderabad'}
      assigns[:result].should_not be nil
      assigns[:result].class.should == Array
      assigns[:result].size.should == 1
      assigns[:result].first.should == "Madhapur"
    end
    it "should return empty array of locations " do
      get 'location_search', {:q => 'xxxx', :city => 'Hyderabad'}, :format => :json
      assigns[:result].class.should == Array
      assigns[:result].first.should == nil
    end
    it "should rewrite the search value before search " do
      get 'location_search', {:q => 'MadHap', :city => 'Hyderabad'}, :format => :json
      assigns[:result].should_not be nil
      assigns[:result].class.should == Array
      assigns[:result].size.should == 1
      assigns[:result].first.should == "Madhapur"
    end
  end

  describe "geo_location_parameters" do
    it "should return hyderabad" do
      get "geo_location_parameters" , {:lat =>"(17.385044, 78.486671)"}
      session[:city].should == " Hyderabad"
      response.should be_success
    end

    it "should return Bangalore" do
      get "geo_location_parameters" , {:lat =>"(12.874642,77.827148)"}
      session[:city].should == " Bengaluru"
      response.should be_success
    end

    it "should return New Delhi" do
      get "geo_location_parameters" , {:lat =>"(28.48736162133368, 77.14599609375)"}
      session[:city].should == " New Delhi"
      response.should be_success
    end

    it "should return Kanpur" do
      get "geo_location_parameters" , {:lat =>"(26.460083,80.266113)"}
      session[:city].should == " Kanpur"
      response.should be_success
    end
  end
end
