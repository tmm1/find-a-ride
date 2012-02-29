class RideRequestsController < RidesController 
  before_filter :authenticate_user!
  
  def new
    render :layout => false
  end
  
  def create
   @ride_request = current_user.ride_requests.new(params[:ride_request])
    respond_to do |format|
      if @ride_request.save
        format.html { redirect_to(rides_path, :notice => 'Your Ride Request was successfully created.') }
      else
        format.html { render :action => "new" }
        format.js {render :json => @ride_request.errors }
      end
    end
  end

end