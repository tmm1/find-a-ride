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
end
