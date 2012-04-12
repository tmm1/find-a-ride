require 'spec_helper'

describe InvitesController do
  render_views
  include Devise::TestHelpers
  before(:all) do
    @login_user = Factory(:user)
  end
  
  describe "#index" do
    it "should render index" do
      sign_in @login_user
      get 'index', {:user_id => @login_user.id}
      response.should be_success
      response.should render_template(:invite)
    end
  end
end
