class HomeController < ApplicationController
  def about
  end
  
  def index
    if user_signed_in?
      redirect_to rides_path
    end
  end
  
  def contact
    contact_email = ContactMailer.contact_email(params)
    if contact_email.deliver
      render :text => 'success', :status => 200
    else
      render :text => 'failed', :success => 500
    end
  end
end
