class RidesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :restrict_inactive_user

  authorize_resource

  def index   
    @ride_offers = Ride.filter(params).paginate(:page => params[:page], :per_page => 5)
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
      if params[:ride] && @ride.valid?
        format.html { redirect_to(search_ride_offers_path(params[:ride].merge({:from => :search}))) }
      else
        format.html {}
      end
    end
  end

  def destroy
    @ride = Ride.find(params[:id])
    if @ride.deletable? and can?(:delete, @ride)
      @ride.destroy
      flash.now[:success] = "The #{@ride.humanize_type} was deleted successfully"
    else
      flash.now[:error] = "The #{@ride.humanize_type} was not deleted"
    end

    get_rides
    respond_to do |format|
      format.js { render :action => :list }
    end
  end

  private

  def get_rides
    @ride_requests = current_user.ride_requests.order("created_at DESC").paginate(:page => params[:ride_request_page], :per_page => 5)
    @ride_offers = current_user.ride_offers.order("created_at DESC").paginate(:page => params[:ride_offer_page], :per_page => 5)
  end
end

