require 'spec_helper'

describe RidesController do
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
      assigns(:ride_request).should_not be nil
      assigns(:ride_offer).should_not be nil
    end
  end
end
