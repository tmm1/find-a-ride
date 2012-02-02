require 'spec_helper'

describe HomeController do
  describe "#index" do
    it "should render index" do
      get 'index'
      response.should be_success
      response.should render_template(:index)
    end
  end

  describe "#about" do
    it "should render about" do
      get 'about'
      response.should be_success
      response.should render_template(:about)
    end
  end
  
  describe "#request_ride" do
    it "should request ride" do
      get 'request_ride'
      response.should be_success
      response.should render_template(:request_ride)
    end
  end
  
  describe "#offer_ride" do
    it "should offer_ride" do
      get 'offer_ride'
      response.should be_success
      response.should render_template(:offer_ride)
    end
  end
end
