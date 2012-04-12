require 'spec_helper'

describe InviteController do
  render_views
  include Devise::TestHelpers
  before(:all) do
    @login_user = Factory(:user)
    @login_user.confirm!
  end

  describe "#invite" do
    it "should render invite" do
      get 'invite', {:user_id => @login_user.id}
      response.should be_success
      response.should render_template(:invite)
    end
  end

  describe "#send_invite" do
    it "should render success text and email count should increase by 1" do
      sign_in @login_user
      email_count = ActionMailer::Base.deliveries.size
      xhr :get ,:send_invites , {:email => "reshu@gmail.com, reshuban@gmail.com", :user_id =>@login_user.id}
      ActionMailer::Base.deliveries.size.should == email_count+1
      response.should be_success
      response.body.should == 'success'
    end

  end


end
