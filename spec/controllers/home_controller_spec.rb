require 'spec_helper'

describe HomeController do
  render_views
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

  describe "#authorize" do
    it "should render authorize" do
      post 'authorize'
      response.should be_success
      response.should render_template(:authorize)
    end
  end

  describe "#contact" do
    before(:all) do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries.clear
    end
    
    it 'should allow user to contact successfully' do
      info = {'name' => 'john emburey', 'email' => 'john@gmail.com', 'about' => 'General Feedback', 'comments' => 'Hey! this is a great site, keep it going!'}
      Resque.should_receive(:enqueue).with(ContactMailer, :contact_email, info).and_return(true)
      post 'contact', info
      response.should be_success
      response.body.should == 'success'
    end
  end

  describe "#inactive" do
    it "should render inactive page" do
      @inactive_user = Factory(:user, :inactive => true)
      sign_in @inactive_user
      get :inactive
      response.should be_success
      response.should render_template(:inactive)
    end


    it "should render inactive page with the flash message" do
      @inactive_user = Factory(:user, :inactive => true)
      sign_in @inactive_user
      get :inactive
      response.should be_success
      response.should render_template(:inactive)
      request.flash[:notice].should == "Your account was updated successfully"
    end
  end
end


