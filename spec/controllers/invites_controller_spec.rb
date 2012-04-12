require 'spec_helper'

describe InvitesController do
  render_views
  include Devise::TestHelpers
  before(:all) do
    @login_user = Factory(:user)
  end

  describe "#invite" do
    it "should render index" do
      sign_in @login_user
      get 'index', {:user_id => @login_user.id}
      response.should be_success
      response.should render_template(:index)
    end
  end

  describe "#send_invite" do
    before(:all) do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries.clear
    end
    
    it "should send the invite email to the provided email list" do
      sign_in @login_user
      xhr :post, :send_invite, {:email => "reshu@gmail.com, reshuban@gmail.com", :user_id => @login_user.id}
      ActionMailer::Base.deliveries.size.should == 1
      response.should be_success
      response.body.should == 'success'
    end
  end
end
