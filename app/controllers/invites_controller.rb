class InvitesController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def send_invite
    emails = params[:email].split(",")
    ContactMailer.referral_email(current_user, {:email => emails}).deliver
    respond_to do |format|
      format.js {render :text => 'success' , :status => 200}
    end
  end
  
end
