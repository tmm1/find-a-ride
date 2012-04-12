class InviteController < ApplicationController

  def invite
  end

  def send_invites
    emails = params[:email].split(",")
    ContactMailer.referral_email(current_user, {:email => emails}).deliver
    render :text => 'success', :status => 200
  end
  
end
