require 'spec_helper'

describe HookUpsController do
  render_views
  include Devise::TestHelpers
  
  before(:all) do
    @login_user = Factory(:user)
    @contactee_user = Factory(:user)
  end
  
  describe "#new" do
    it "should render new" do  
      sign_in @login_user
      get 'new', {:user_id => @login_user.id, :id => @contactee_user.id, :orig => 'Madhapur', :dest => 'Kondapur', :time => 2.days.ago.to_s(:short)}
      response.should be_success
      response.should render_template(:new)
      assigns(:contactee).should == @contactee_user
      assigns(:origin).should == 'Madhapur'
      assigns(:dest).should == 'Kondapur'
      assigns(:time).should == 2.days.ago.to_s(:short)
    end
  end

  describe "#create" do
    it 'should allow the user to hook up successfully' do
      sign_in @login_user
      ride = Factory(:ride)
      params = {:contactee_id => @contactee_user.id, :contacter_id => @login_user.id, :message => 'Hook me up!', :hookable => ride}
      post 'create', {:user_id => @login_user.id, :hook_up => params}
      response.should be_success
      response.body.should == 'success'
      hook_up = assigns(:hook_up)
      hook_up.should_not be nil
      hook_up.message.should == params[:message]
      hook_up.contacter.should == User.find(@login_user.id)
      hook_up.contactee.should == User.find(@contactee_user.id)
      hook_up.hookable.id.should == ride.id
    end
    
    it 'should not allow users to hook up without a ride' do
      sign_in @login_user     
      params = {:contactee_id => @contactee_user.id, :contacter_id => @login_user.id, :message => 'Hook me up!' }
      post 'create', {:user_id => @login_user.id, :hook_up => params}
      response.should be_success
      response.body.should == 'failed'     
    end
    
    it 'should not allow users to hook up with out a ride' do
      sign_in @login_user     
      params = {:contactee_id => @contactee_user.id, :contacter_id => @login_user.id, :message => 'Hook me up!' }
      post 'create', {:user_id => @login_user.id, :hook_up => params}
      response.should be_success
      response.body.should == 'failed'     
    end
  end
  
  describe "#index" do
    before(:each) do
      ride = Factory(:ride)
      @hook_up1 = HookUp.create({:contactee_id => @contactee_user.id, :contacter_id => @login_user.id, :message => 'Hook me up!', :hookable => ride})
      @hook_up2 = HookUp.create({:contactee_id => @contactee_user.id, :contacter_id => @login_user.id, :message => 'Hook me up!', :hookable => ride})
      @hook_up3 = HookUp.create({:contactee_id => @contactee_user.id, :contacter_id => @login_user.id, :message => 'Hook me up!', :hookable => ride})
      @hook_up4 = HookUp.create({:contactee_id => @contactee_user.id, :contacter_id => @login_user.id, :message => 'Hook me up!', :hookable => ride})
      @hook_up5 = HookUp.create({:contactee_id => @contactee_user.id, :contacter_id => @login_user.id, :message => 'Hook me up!', :hookable => ride})
      @hook_up6 = HookUp.create({:contactee_id => @contactee_user.id, :contacter_id => @login_user.id, :message => 'Hook me up!', :hookable => ride})
    end
    
    it 'should render index' do
      sign_in @login_user
      get 'index', {:user_id => @login_user.id}
      response.should be_success
      response.should render_template(:index)
      assigns(:recent_hook_ups).should have(5).things
    end
  end
  
end
