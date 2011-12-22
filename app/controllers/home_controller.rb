class HomeController < ApplicationController

  def about
  end
  
  def request_for_ride
    render :layout => false
  end
  
  def offer_for_ride
    render :layout => false
  end
 
end
