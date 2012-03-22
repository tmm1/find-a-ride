class RideOffersController < RidesController 
  before_filter :authenticate_user!

  def create
   @ride_offer = current_user.ride_offers.new(params[:ride_offer])
   respond_to do |format|
      if @ride_offer.save
        format.html { redirect_to(rides_path, :notice => 'Your Ride Offer was successfully created.') }
      else
        format.html { render :action => "new" }
        format.js {render :json => @ride_offer.errors }
      end
    end
  end
end