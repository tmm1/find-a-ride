class HomeController < ApplicationController
  def about
  end
  
  def index
    if user_signed_in?
      redirect_to rides_path
    end
  end
  
  def contact
    
  end
end
