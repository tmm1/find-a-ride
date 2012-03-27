class RidesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @ride_request = RideRequest.new
    @ride_offer = RideOffer.new
  end
end
