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
     
     it "should redirect to the rides index when the user is signed in" do
       @login_user = Factory(:user)
       @login_user.confirm!
       sign_in @login_user
       get 'index'
       response.should be_redirect
     end
   end
end


