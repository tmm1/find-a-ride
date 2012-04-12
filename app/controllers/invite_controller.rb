class InviteController < ApplicationController

  def invite
  end

  def send_invites
    emails = params[:email].split(",")
    render :text => 'success', :status => 200
  end
  
end
