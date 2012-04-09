class HomeController < ApplicationController
  def about
  end
  
  def index
  end
  
  def contact
    contact_email = ContactMailer.contact_email(params)
    if contact_email.deliver
      render :text => 'success', :status => 200
    else
      render :text => 'failed', :status => 200
    end
  end

  def inactive
    if current_user.inactive
      flash.now[:notice]="Your account was updated successfully"
    end
  end
end
