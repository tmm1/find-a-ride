require 'spec_helper'

describe "Application management" do
  it "accessing unknown action and redirects to the not found page" do
    get "somthing"
    response.status.should eql 404
  end

  it "ride request other than GET" do
    params = Factory.attributes_for(:ride_request)
    get "/rides"
    @rides = @ride_request
    response.status.should eql 302
  end

  it "Not Acceptable" do
    get "/location_search" , :q => nil
    response.status.should eql 406
  end
  
end