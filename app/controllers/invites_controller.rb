class InvitesController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def send_invite
    invitees = params[:email].split(",")
    ContactMailer.invite_email(current_user, invitees).deliver
    render :text => 'success', :status => 200
  end
end
