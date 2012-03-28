class RideOffersController < RidesController 
  before_filter :authenticate_user!
  
  def new
  end

  def create
   @ride_offer = current_user.ride_offers.new(params[:ride_offer])
   respond_to do |format|
      if @ride_offer.save
        format.html { redirect_to(search_ride_requests_path(params[:ride_offer]), :notice => 'Yay! Your offer was created successfully.') }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def search
    results = RideOffer.search(params)
    @paginated_results = results.paginate(:page => params[:page], :per_page => 5)
    respond_to do |format|
      format.html { render 'rides/results' }
    end
  end
end