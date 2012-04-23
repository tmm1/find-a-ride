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
      xhr :post, :send_invite, {:email_list => ["reshu@gmail.com, reshuban@gmail.com"], :user_id => @login_user.id}
      ActionMailer::Base.deliveries.size.should == 1
      response.should be_success
      response.body.should == 'success'
    end

    it "should send the failure status when no emails in the list" do
      sign_in @login_user
      xhr :post,  :send_invite, {:email_list => [],:user_id => @login_user.id}
      response.should be_success
      response.body.should == 'failed'
    end
  end

  describe "#get_gmail_contacts" do
    it "should fail fetching gmail contacts" do
      sign_in @login_user
      get 'get_gmail_contacts', { :login => "contactsuser@gmail.com", :password => "wrongpwd", :user_id => @login_user.id, :format => :js }
      response.should have_content_type 'text/javascript'
      assigns[:gmail_contacts].should be nil
    end
    
    it "should fetch no gmail contacts" do
      sign_in @login_user
      get 'get_gmail_contacts', { :login => "onthewaytester@gmail.com", :password => "0ntheway", :user_id => @login_user.id, :format => :js }
      response.should have_content_type 'text/javascript'
      assigns[:gmail_contacts].should be_empty
    end
    
    it "should fetch all gmail contacts successfully" do
      sign_in @login_user
      get 'get_gmail_contacts', { :login => "contactsuser@gmail.com", :password => "importcontacts", :user_id => @login_user.id, :format => :js }
      response.should have_content_type 'text/javascript'
      assigns[:gmail_contacts].should_not be_empty
      assigns[:gmail_contacts].should have(1).things
    end
  end

#  describe "#facebook invite" do
#    it "should send invitation to facebook friends" do
#      sign_in @login_user
#      get "facebook_invite_response", {}
#      response.should be_success
#      response.should render_template(:facebook_invite)
#      request.flash[:notice].should == "Thanks! Your invite was successfully sent."
#    end
#  end

end
