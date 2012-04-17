class InvitesController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def send_invite
    #TODO: consider sending out individual emails (and not a single one) for privacy sake
    ContactMailer.invite_email(current_user, params[:email_list]).deliver
    render :text => 'success', :status => 200
  end

  def get_gmail_contacts
    @error_msg = ''
    begin
      @all_contacts = FetchContacts.get_gmail_contacts(params[:login], params[:password])
    rescue Exception => ex
      @error_msg = (ex.message.include?("Username")) ? ex.message : "Have some problem fetching your Contacts, please try again."
    end
    respond_to do |wants|
      if @error_msg != ''
        wants.json { render :json => { :error_msg => @error_msg } }
      else
        wants.js {}
      end
    end
  end

end
