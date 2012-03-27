class RideOffersController < RidesController 
  before_filter :authenticate_user!
  
  def new
  end

  def create
   @ride_offer = current_user.ride_offers.new(params[:ride_offer])
   respond_to do |format|
      if @ride_offer.save
        format.html { redirect_to(rides_path, :notice => 'Your offer was put in successfully.') }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
end