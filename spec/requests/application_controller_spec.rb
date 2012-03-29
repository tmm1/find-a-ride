require 'spec_helper'

describe "Application management" do
 
  it "accessing unknown action and render not found page" do
    get "somthing"
    response.status.should eql 404
    response.should render_template(:not_found)
  end

  it "accessing search with out params and render internal server error page" do
    @login_user = Factory(:user)
    @login_user.confirm!
    post "/users/sign_in" , :user =>{:email => @login_user.email , :password => "test1234" }  
    get "ride_requests/search" 
    response.status.should eql 500
    response.should render_template(:internal_server_error)
  end

end