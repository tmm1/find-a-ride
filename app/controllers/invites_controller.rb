class InvitesController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def send_invite
    emails = params[:email].split(",")
    render :text => 'success', :status => 200
  end
  
end
