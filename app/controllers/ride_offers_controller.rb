class RideOffersController < RidesController 
  before_filter :authenticate_user!
  
  def new
    render :layout => false
  end
  
  def create
    
  end
end