class RidesController < ApplicationController
  before_filter :setup_params
  
  def search
    @origin = params[:origin] 
    @dest = params[:dest]
    @matcher = params[:matcher]
    results = User.send("find_matches_for_#{@matcher}", @origin, @dest)
    @paginated_results = results.paginate(:page => params[:page], :per_page => 5)
    respond_to do |format|
      format.html { render :partial => 'search_results' }
    end
  end
  
  def contact
    Ride.create_ride(@ride_params)
  end
  
  private
  
  def setup_params
    @ride_params = {:contactee_id => params[:contactee_id], :contactor_id => params[:contactor_id], :user_info => params[:user_info], :message => params[:message], :matcher => params[:matcher]}
  end
end
