class RidesController < ApplicationController
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
    Ride.create_ride(params)
    respond_to do |format|
      format.html {render :text => 'Your message was successfully sent. Thank you!', :status => 200 }
    end
  end
end
