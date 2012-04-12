require 'spec_helper'

describe InviteController do
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

end
