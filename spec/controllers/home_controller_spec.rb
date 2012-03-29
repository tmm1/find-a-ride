require 'spec_helper'

describe HomeController do
  include Devise::TestHelpers
  describe "#about" do
    it "should render about" do
      get 'about'
      response.should be_success
      response.should render_template(:about)
    end
  end

  describe "#index" do
    it "should render index when user is not signed in" do
      get 'index'
      response.should be_success
      response.should render_template(:index)
    end    
  end
  
  describe "#contact" do
    before(:all) do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries.clear
    end
    
    it 'should allow user to contact successfully' do
      post 'contact', {:name => 'john emburey', :email => 'john@gmail.com', :about => 'General Feedback', :comments => 'Hey! this is a great site, keep it going!' }
      response.should be_success
      response.body.should == 'success'
      ActionMailer::Base.deliveries.size.should == 1
    end
  end
end


