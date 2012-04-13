require 'spec_helper'

describe User do
  describe "#attributes and methods" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    it { should_not allow_value('1230').for(:mobile) }
    it { should_not allow_value('123456789000').for(:mobile)}
    it { should_not allow_value('dadd122112').for(:mobile)}
    it { should allow_value('1234567890').for(:mobile)}
    it { should_not allow_value('1230').for(:landline) }
    it { should_not allow_value('dasdas44a').for(:landline) }
    it { should allow_value('1234567890').for(:landline)}

    before(:each) do
      @user = Factory(:user, :first_name => 'testio', :last_name => 'rockio')
    end

    it "should reset passowrd with new password" do
      @user.update_with_password({:password => 'changeme!',:password_confirmation => 'changeme!'})
      @user.password.should == 'changeme!'
    end

    it "should update user info without password" do
      @user.update_with_password({:first_name => 'Devise!'})
      @user.first_name.should == 'Devise!'
    end

    it "should update user info with password" do
      @user.update_with_password({:first_name => 'Devise!',:last_name => 'Devise Last Name',:password => 'changemeagain!',:password_confirmation => 'changemeagain!'})
      @user.first_name.should == 'Devise!'
      @user.last_name.should == 'Devise Last Name'
      @user.password.should == 'changemeagain!'
    end

    it "should return the full name of the user" do
      @user.full_name.should == 'Testio Rockio'
    end

    it "should use full name alias method for name of the user" do
      @user.name.should == @user.full_name
    end

    it "should update inactive attribute successfully" do
      @user.update_attributes({:inactive => 1})
      @user.save.should be true
      @user.inactive.should be true
    end

    it 'should return active status' do
      @user = Factory(:user, :inactive => true)
      @user.active?.should be false
      @user.update_attribute :inactive, false
      @user.active?.should be true
    end

    it 'should return the phone' do
      @user.mobile = '3012211221'
      @user.landline = '3032211221'
      @user.phone.should == '3012211221'
    end

    describe "#mobile validation" do
      before(:all) do
        @user = Factory(:user)
      end

      it "should fail if mobile number is required and is not provided" do
        @user.mobile_required = 'true'
        @user.mobile = ""
        @user.should_not be_valid
        @user.errors.to_a.should include("Mobile can't be blank")
      end

      it "should not fail if mobile number is not required and is not provided" do
        @user.mobile_required = 'false'
        @user.mobile = ""
        @user.should be_valid
      end
    end
  end

  describe "#active" do
    it 'should return all active users' do
      @active_user1 = Factory(:user)
      @active_user2 = Factory(:user)
      @active_user3 = Factory(:user)
      @inactive_user1 = Factory(:user, :inactive => true)
      @inactive_user2 = Factory(:user, :inactive => true)
      User.active.should_not include @inactive_user1
      User.active.should_not include @inactive_user2
    end
  end

  describe "#profile picture" do
    before(:all) do
      @user = Factory(:user)
    end

    it "should fail attachment content_type validation" do
      @user.photo = File.new("spec/data/sample.bmp")
      @user.save.should be false
      @user.errors.to_a.should include("Photo content type must be of type jpeg, png or gif")
    end

    it "should fail attachment file size validation" do
      @user.photo = File.new("spec/data/image_6mb.jpg")
      @user.save.should be false
      @user.errors.to_a.should include("Photo file size cannot be greater than 3 MB")
    end

    # it "should save attachment successfully" do note: COMMENTED TO AVOID  BLOATING S3 STORAGE SIZE
    #       @user.photo = File.new("spec/data/sample.png")
    #       @user.save.should be true
    #       @user.photo_content_type.should == "image/png"
    #       @user.photo_file_size.should < 3.megabytes
    #       @user.photo_file_name.should == "sample.png"
    #       @user.photo.url.include?("http://s3.amazonaws.com/find-a-ride-test/original/#{@user.id}/#{@user.photo_file_name}").should be true
    # end
  end

  describe "#save" do
    before(:all) do
      @user = Factory.build(:user)
      @invalid_user = Factory.build(:user, :password_confirmation => "unmatched password")
    end

    it "should save a valid user" do
      @user.save.should be true
    end

    it "should not save an invalid user" do
      @invalid_user.save.should_not be true
      @invalid_user.errors.to_a.should include("Password doesn't match confirmation")
    end

    it "should not require current password to update account" do
      @user.update_with_password({:email => "test123@test.com"}).should be true
      @user.email.should == "test123@test.com"
    end

    it { should validate_acceptance_of(:terms) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    it { should_not allow_value('1230').for(:mobile) }
    it { should_not allow_value('0123456789').for(:mobile) }
    it { should allow_value('1234567890').for(:mobile)}
    it { should_not allow_value('1230').for(:landline) }
    it { should allow_value('1234567890').for(:landline)}

    it { should allow_mass_assignment_of(:email) }
    it { should allow_mass_assignment_of(:password) }
    it { should allow_mass_assignment_of(:password_confirmation) }
    it { should allow_mass_assignment_of(:remember_me) }
    it { should allow_mass_assignment_of(:first_name) }
    it { should allow_mass_assignment_of(:last_name) }
    it { should allow_mass_assignment_of(:mobile) }
    it { should allow_mass_assignment_of(:landline) }
    it { should allow_mass_assignment_of(:terms) }

    it { should_not allow_mass_assignment_of(:encrypted_password)}
    it { should_not allow_mass_assignment_of(:reset_password_token)}
    it { should_not allow_mass_assignment_of(:reset_password_sent_at)}
    it { should_not allow_mass_assignment_of(:remember_created_at)}
    it { should_not allow_mass_assignment_of(:sign_in_count)}
    it { should_not allow_mass_assignment_of(:current_sign_in_at)}
    it { should_not allow_mass_assignment_of(:last_sign_in_at)}
    it { should_not allow_mass_assignment_of(:current_sign_in_ip)}
    it { should_not allow_mass_assignment_of(:last_sign_in_ip)}

    it { should_not allow_mass_assignment_of(:confirmation_token)}
    it { should_not allow_mass_assignment_of(:confirmed_at)}
    it { should_not allow_mass_assignment_of(:confirmation_sent_at)}

  end

  describe "twitter oauth" do
    before(:all) do
      @email = Faker::Internet.email
      @user1 = Factory(:user, :first_name  => 'amar', :last_name => 'singh', :email => @email)
    end

    it "should not create a duplicate user if the user is already in the system" do
      match = User.find_for_twitter_oauth(@email, 'amar', 'singh', nil)
      match.should == @user1
    end

    it "should create a new user if the user doesnt exist in the system" do
      @email = Faker::Internet.email
      User.find_by_email(@email).should == nil
      match = User.find_for_twitter_oauth(@email, 'rahul', 'singh', nil)
      match.should_not == @user1
      match.should ==  User.find_by_email(@email)
    end
  end

  describe "facebook oauth" do
    before(:all) do
      @email = Faker::Internet.email
      @user1 = Factory(:user, :first_name  => 'ask', :last_name => 'singh', :email => @email)
    end
    it "should not create a duplicate user if the user is already in the system." do
      @user_info = {"extra" => {"user_hash" => {"email" => @email, "first_name" => "ask", "last_name" => "singh"}}}
      match = User.find_for_facebook_oauth(@user_info, nil)
      match.should == @user1
    end

    it "should create a new user if the user doesnt exist in the system" do
      @email = Faker::Internet.email
      User.find_by_email(@email).should == nil
      @user_info = {"extra" => {"user_hash" => {"email" => @email, "first_name" => "Rahul", "last_name" => "singh"}}}
      match = User.find_for_facebook_oauth(@user_info, nil)
      match.should_not == @user1
      match.should ==  User.find_by_email(@email)
    end
  end
  
  describe "aggregrated recent hook ups" do
    before(:all) do
      @user1 = Factory(:user)
      @user2 = Factory(:user)
      @ride1 = Factory(:ride_request)
      @ride2 = Factory(:ride_offer)
      @ride3 = Factory(:ride_request)
      @hook_up1 = Factory(:hook_up, :contacter => @user1, :contactee => @user2, :hookable => @ride1)
      @hook_up2 = Factory(:hook_up, :contacter => @user1, :contactee => @user2, :hookable => @ride2)
      @hook_up3 = Factory(:hook_up, :contacter => @user2, :contactee => @user1, :hookable => @ride3)
    end
    
    it 'should return the recent hook ups for the user' do
      list = @user1.aggregrated_recent_hook_ups
      list.should have(3).things
      list.should == [@hook_up3, @hook_up2, @hook_up1]
    end
  end
end



# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  last_name              :string(255)
#  mobile                 :string(255)
#  landline               :string(255)
#  photo_file_name        :string(255)
#  photo_content_type     :string(255)
#  photo_file_size        :integer(4)
#  photo_updated_at       :datetime
#  inactive               :boolean(1)      default(FALSE)
#

