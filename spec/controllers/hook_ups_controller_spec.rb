require 'spec_helper'

describe HookUpsController do
  render_views
  include Devise::TestHelpers
  before(:all) do
    @login_user = Factory(:user)
    @login_user.confirm!
  end
  describe "#new" do
    it "should render new" do  
      sign_in @login_user
      get 'new'
      response.should be_success
      response.should render_template(:new)
    end
  end

  describe "#create" do
    it 'should allow users to hook up successfully' do
      sign_in @login_user
      contactee = Factory(:user, :first_name => 'test', :last_name => 'test',:inactive => false)
      params = {:contactee_id => contactee.id, :contacter_id => @login_user.id, :message => 'Hook me up' }
      post 'create',:hook_up => params
      response.should be_success
      response.body.should == 'success'
    end
  end
  
end
