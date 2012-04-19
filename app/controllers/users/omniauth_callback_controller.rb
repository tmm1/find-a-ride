class Users::OmniauthCallbackController < ApplicationController
  def facebook
    puts "111111111111"+params.inspect
    puts "111111111111"+env["omniauth.auth"].inspect
    @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    if @user && @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def twitter
    session[:twitter] = env["omniauth.auth"]["extra"]["user_hash"]["name"]
    if env["omniauth.auth"]["uid"]
      @user = User.new
    end
  end

  def register_user_with_twitter
    @user = User.new(params["user"])
    if !@user.valid? && !@user.errors[:email].blank?
      render :twitter
    else
      name = session[:twitter].split(" ")
      @user = User.find_for_twitter_oauth(params["user"]["email"], name[0], name[1], current_user)
      sign_in_and_redirect @user, :event => :authentication
    end
  end

end
