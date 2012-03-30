require 'spec_helper'

describe RidesController do
  render_views
  include Devise::TestHelpers
  before(:all) do
    @login_user = Factory(:user)
    @login_user.confirm!
  end
  
  describe "#index" do
    it "should render index" do     
      sign_in @login_user
      get 'index'
      response.should be_success
      response.should render_template(:index)
    end
  end
end
