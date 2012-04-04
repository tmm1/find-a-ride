require 'spec_helper'

describe HookUpsController do
  render_views
  include Devise::TestHelpers
  
  before(:all) do
    @login_user = Factory(:user)
    @contactee_user = Factory(:user)
    @login_user.confirm!
  end
  
  describe "#new" do
    it "should render new" do  
      sign_in @login_user
      get 'new', {:id => @contactee_user.id, :orig => 'Madhapur', :dest => 'Kondapur', :time => 2.days.ago.to_s(:short)}
      response.should be_success
      response.should render_template(:new)
      assigns(:contactee).should == @contactee_user
      assigns(:origin).should == 'Madhapur'
      assigns(:dest).should == 'Kondapur'
      assigns(:time).should == 2.days.ago.to_s(:short)
    end
  end

  describe "#create" do
    it 'should allow users to hook up successfully' do
      sign_in @login_user
      ride = Factory(:ride)
      params = {:contactee_id => @contactee_user.id, :contacter_id => @login_user.id, :message => 'Hook me up!' , :hookable_type => "RideRequest"  , :hookable_id => ride.id }
      post 'create', :hook_up => params
      response.should be_success
      response.body.should == 'success'
      assigns(:hook_up).should_not be nil
      assigns(:hook_up).message.should == 'Hook me up!'
    end

    it 'should not allow users to hook up with out a ride' do
      sign_in @login_user     
      params = {:contactee_id => @contactee_user.id, :contacter_id => @login_user.id, :message => 'Hook me up!' }
      post 'create', :hook_up => params
      response.should be_success
      response.body.should == 'failed'     
    end
  end
  
end
