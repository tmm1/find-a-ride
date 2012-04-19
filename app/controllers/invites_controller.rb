class InvitesController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def send_invite
    #TODO: consider sending out individual emails (and not a single one) for privacy sake
    if !params[:email_list].empty?
      ContactMailer.invite_email(current_user, params[:email_list]).deliver
      render :text => 'success', :status => 200
    else
      render :text => 'failed', :status => 200
    end
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

  def facebook_invite_response
    puts "sssssssssssssss"+response.inspect
    puts "sssssssssssssss"+params.inspect
    flash[:success]="Thanks! Your invite was successfully sent."
    redirect_to(user_invites_path(current_user))
  end

end
