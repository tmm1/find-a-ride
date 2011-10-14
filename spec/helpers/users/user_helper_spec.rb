require 'spec_helper'

describe Users::UserHelper do

  it 'should return personal info error count' do
    user = Factory(:user)
    user.update_attributes({:email => '', :first_name => '', :last_name => ''})
    user_errors = helper.errors_by_accordion_type(user.errors)
    user_errors[:personal_info_errors].length.should == 3
  end

  it 'should return contact info error count' do
    user = Factory(:user)
    user.update_attributes({:mobile => '9876sd3210', :landline => '244aa66210'})
    user_errors = helper.errors_by_accordion_type(user.errors)
    user_errors[:contact_info_errors].length.should == 2
  end

end
