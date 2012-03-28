class RideRequestsController < RidesController 
  before_filter :authenticate_user!
  
  def new
  end

  def create
   @ride_request = current_user.ride_requests.new(params[:ride_request])
    respond_to do |format|
      if @ride_request.save
        format.html { redirect_to(rides_path, :notice => 'Your request was put in successfully.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def search
    results = RideRequest.search(params)
    @paginated_results = results.paginate(:page => params[:page], :per_page => 5)
    respond_to do |format|
      format.html { render :partial => 'results' }
    end
  end
end