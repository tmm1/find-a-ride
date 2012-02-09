require 'spec_helper'

describe HomeController do
  describe "#about" do
    it "should render about" do
      get 'about'
      response.should be_success
      response.should render_template(:about)
    end
  end
  
  describe "#index" do
     it "should render index" do
       get 'index'
       response.should be_success
       response.should render_template(:index)
     end
   end
end
