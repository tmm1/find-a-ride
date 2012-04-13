class RidesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :restrict_inactive_user

  def index
    @ride = Ride.new
  end
  
  def list
    get_rides
  end

  def new
    @ride_request = RideRequest.new
    @ride_offer = RideOffer.new
  end
  
  def search
    @ride = Ride.new(params[:ride])
    respond_to do |format|
      if @ride.valid?
        format.html { redirect_to(search_ride_offers_path(params[:ride].merge({:from => :search}))) }
      else
        format.html { render :action => 'index' }
      end
    end
  end

  def destroy
    @ride = Ride.find(params[:id])
    @ride.destroy if @ride.deletable? and @ride.owner?(current_user)
    flash.now[:notice] = "Your ride was deleted successfully."
  rescue
    flash.now[:error] = "You ride was not deleted"
  ensure
    get_rides
    respond_to do |format|
      format.js { render :action => :list }
    end
  end

  private

  def get_rides
    @ride_requests = current_user.ride_requests.paginate(:page => params[:ride_request_page], :per_page => 5)
    @ride_offers = current_user.ride_offers.paginate(:page => params[:ride_offer_page], :per_page => 5)
  end
end

