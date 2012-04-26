require 'spec_helper'

describe AlertsController do
  render_views
  include Devise::TestHelpers

  describe "#index" do
    before(:all) do
      Alert.destroy_all
      @login_user = Factory(:user)
      @user = Factory(:user)
      @ride1 = Factory(:ride_request)
      @ride2 = Factory(:ride_offer)
      @hook_up1 = Factory(:hook_up, :contacter => @user, :contactee => @login_user, :hookable => @ride1)
      @hook_up2 = Factory(:hook_up, :contacter => @user, :contactee => @login_user, :hookable => @ride2)
    end
    
    it 'should render the index of alerts' do
      sign_in @login_user
      get "index", {:user_id => @login_user.id}
      response.should be_success
      response.should render_template(:index)
      assigns(:alerts).should_not be nil
      assigns(:alerts).should have(2).things
      assigns(:alerts).should include @hook_up1.alert
      assigns(:alerts).should include @hook_up2.alert
    end
  end

  describe "#read" do
    before(:all) do
      @login_user = Factory(:user)
      @alert = Factory(:alert)
    end

    after(:all) do
      RideOffer.destroy_all
      RideRequest.destroy_all
      Alert.destroy_all
    end

    it "should fail changing of state" do
      sign_in @login_user
      @alert.state.should == 'unread'
      get "read", {:id => @alert.state}
      response.should have_content_type 'text/html'
      @alert.reload
      @alert.state.should_not == 'read'
      @alert.state.should == 'unread'
    end

    it "should the change state to read" do
      sign_in @login_user
      @alert.state.should == 'unread'
      get "read", {:id => @alert.id}
      response.should have_content_type 'text/html'
      @alert.reload
      @alert.state.should == 'read'
    end
  end

end
