class RideRequestsController < RidesController 
  before_filter :authenticate_user!
  before_filter :restrict_inactive_user
  
  authorize_resource

  def new
  end

  def create
    @ride_request = current_user.ride_requests.new(params[:ride_request])
    respond_to do |format|
      if @ride_request.save
        format.html { redirect_to(search_ride_offers_path(params[:ride_request].merge({:from => :create})), :notice => 'Yay! Your request was created successfully.') }
      else
        if !@ride_request.errors[:base].empty?
          flash.now[:error] = @ride_request.errors[:base].first
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
      format.html { render 'results' }
      format.js {}
    end
  end
end
