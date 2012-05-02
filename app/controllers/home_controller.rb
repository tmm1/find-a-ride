class HomeController < ApplicationController
  layout "application", :except => [:authorize]
  
  def about
  end
  
  def index
  end

  def authorize
      respond_to do |format|
        format.html # authorize.html.haml
      end
  end
  
  def contact
    info = params.except(:action, :controller)
    if Resque.enqueue(ContactMailer, :contact_email, info)
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
