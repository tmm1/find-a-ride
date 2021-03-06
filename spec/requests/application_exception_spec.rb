require 'spec_helper'

describe "application exceptions" do
  it "should render not found page on routing to an unknown action" do
    get "unknown"
    response.status.should eql 404
    response.should render_template(:not_found)
    assigns(:exception_message).should be nil
    assigns(:exception_trace).should be nil
  end

  it "should render internal server error page on server error" do
    @login_user = Factory(:user)
    post "/users/sign_in", :user =>{:email => @login_user.email , :password => "test1234" }
    get "ride_requests/search" 
    response.status.should eql 500
    response.should render_template(:internal_server_error)
    assigns(:exception_message).should_not be nil
    assigns(:exception_trace).should_not be nil
  end
end