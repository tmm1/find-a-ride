require "spec_helper"

describe UserMailer do

  describe '#perform' do
    before(:each) do
      @email = mock('email', :deliver => true)
      @user = mock_model(User)
      User.should_receive(:find).with(@user.id).and_return(@user)
    end

    it 'should send confirmation instructions' do
      UserMailer.should_receive(:send).with(:confirmation_instructions, @user).and_return(@email)
      UserMailer.perform(:confirmation_instructions, @user.id)
    end

    it 'should send unlock instructions' do
      UserMailer.should_receive(:send).with(:unlock_instructions, @user).and_return(@email)
      UserMailer.perform(:unlock_instructions, @user.id)
    end

    it 'should send reset password instructions' do
      UserMailer.should_receive(:send).with(:reset_password_instructions, @user).and_return(@email)
      UserMailer.perform(:reset_password_instructions, @user.id)
    end
  end
end
