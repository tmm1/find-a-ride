require 'spec_helper'

describe User do
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
      @user.update_attributes({:email => "test123@test.com"}).should be true
      @user.email.should == "test123@test.com"
    end

    it "should not require current password to update account" do
      @user.update_with_password({:email => "test123@test.com"}).should be true
      @user.email.should == "test123@test.com"
    end

    it { should allow_mass_assignment_of(:email) }
    it { should allow_mass_assignment_of(:password) }
    it { should allow_mass_assignment_of(:password_confirmation) }
    it { should allow_mass_assignment_of(:remember_me) }

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
#

