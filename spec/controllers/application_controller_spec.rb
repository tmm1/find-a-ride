require 'spec_helper'

describe ApplicationController do
  describe "#Auto Search" do
    it "should return matched locations" do
      get 'auto_search', {:q => 'madh'}  
      assigns[:result].should_not be nil
      assigns[:result].class.should == Array
      assigns[:result].size.should == 1
      assigns[:result].first.should == "Madhapur"
    end
    it "should return empty array of locations " do
      get 'auto_search', {:q => 'xxxx'},:format => :json
      assigns[:result].class.should == Array
      assigns[:result].first.should == nil
    end
  end
end
