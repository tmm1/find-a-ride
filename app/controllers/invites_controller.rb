class InvitesController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def send_invite
    #TODO: consider sending out individual emails (and not a single one) for privacy sake
    ContactMailer.invite_email(current_user, params[:email_list]).deliver
    render :text => 'success', :status => 200
  end
end
