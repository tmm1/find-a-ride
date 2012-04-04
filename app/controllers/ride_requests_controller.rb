class RideRequestsController < RidesController 
  before_filter :authenticate_user!
  
  def new
  end

  def create
    @ride_request = current_user.ride_requests.new(params[:ride_request])
    respond_to do |format|
      if @ride_request.save
        format.html { redirect_to(search_ride_offers_path(params[:ride_request]), :notice => 'Yay! Your request was created successfully.') }
      else
        if @ride_request.errors[:base].include?("This is an duplicate record try modifying your request criteria.")
          flash[:notice] = "This is an duplicate record try modifying your request criteria."
          format.html { render :action => "new" }
        else
          format.html { render :action => "new"}
        end
      end
    end
  end

  def search
    results = RideRequest.search(params)
    @paginated_results = results.paginate(:page => params[:page], :per_page => 5)
    respond_to do |format|
      format.html { render 'rides/results' }
    end
  end
end