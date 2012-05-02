class InvitesController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def send_invite
    #TODO: consider sending out individual emails (and not a single one) for privacy sake
    if !params[:email_list].empty?
      Resque.enqueue(ContactMailer, :invite_email, current_user.id, params[:email_list])
      render :text => 'success', :status => 200
    else
      render :text => 'failed', :status => 200
    end
  end

  def get_gmail_contacts
    begin
      @gmail_contacts = ContactsService.fetch_gmail_contacts(params[:login], params[:password]) || []
      @gmail_contacts -= User.select(:email).map(&:email) unless @gmail_contacts.empty?
      respond_to do |wants|
        wants.js {}
      end
    rescue Exception => ex
      respond_to do |wants|
        wants.json { render :json => { :error_msg => ex.message } }
      end
    end
  end

end
