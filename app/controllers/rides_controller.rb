class RidesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @ride = Ride.new
  end
  
  def new
    @ride_request = RideRequest.new
    @ride_offer = RideOffer.new
  end
  
  def search
    @ride = Ride.new(params[:ride])
    respond_to do |format|
      if @ride.valid?
        format.html { redirect_to(search_ride_offers_path(params[:ride])) }
      else
        format.html { render :action => 'index' }
      end
    end
  end
end

