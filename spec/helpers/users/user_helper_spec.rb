require 'spec_helper'

describe Users::UserHelper do

  it 'should return personal info error count' do
    user = Factory(:user)
    user.update_attributes({:email => '', :first_name => '', :last_name => ''})
    user_errors = helper.errors_by_accordion_type(user.errors)
    user_errors[:personal_info_errors].length.should == 3
  end

  it 'should return contact info error count with invalid origin and destination' do
    user = Factory(:user)
    user.update_attributes({:mobile => '9876sd3210', :landline => '244aa66210', :origin => 'test', :destination => 'test1', :rider => "1"})
    user_errors = helper.errors_by_accordion_type(user.errors)
    user_errors[:contact_info_errors].length.should == 4
  end

  it 'should return contact info error count with blank origin and destination' do
    user = Factory(:user)
    user.update_attributes({:origin => '', :destination => ''})
    user_errors = helper.errors_by_accordion_type(user.errors)
    user_errors[:contact_info_errors].length.should == 2
  end

  it 'should return contact info error count with no share a ride and offer rides' do
    user = Factory(:user)
    user.update_attributes({:driver => '', :rider => ''})
    user_errors = helper.errors_by_accordion_type(user.errors)
    user_errors[:contact_info_errors].length.should == 1
  end

  it 'should return account setting error count' do
    user = Factory(:user)
    user.update_attributes({:password => "change me", :password_confirmation => "dont change"})
    user_errors = helper.errors_by_accordion_type(user.errors)
    user_errors[:account_setting_errors].length.should == 1
  end

end
