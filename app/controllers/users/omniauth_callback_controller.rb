class Users::OmniauthCallbackController < ApplicationController
  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    if @user && @user.persisted?
#      if !user_signed_in?
#        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
#      end
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

end