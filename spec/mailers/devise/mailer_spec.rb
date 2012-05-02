require "spec_helper"

describe Devise::Mailer do

  describe '#perform' do
    before(:each) do
      @email = mock('email', :deliver => true)
      @user = mock_model(User)
      User.should_receive(:find).with(@user.id).and_return(@user)
    end

    it 'should send confirmation instructions' do
      Devise::Mailer.should_receive(:send).with(:send_confirmation_instructions, @user).and_return(@email)
      Devise::Mailer.perform(:send_confirmation_instructions, @user.id)
    end

    it 'should send unlock instructions' do
      Devise::Mailer.should_receive(:send).with(:send_unlock_instructions, @user).and_return(@email)
      Devise::Mailer.perform(:send_unlock_instructions, @user.id)
    end

    it 'should send reset password instructions' do
      Devise::Mailer.should_receive(:send).with(:send_reset_password_instructions, @user).and_return(@email)
      Devise::Mailer.perform(:send_reset_password_instructions, @user.id)
    end
  end
end
