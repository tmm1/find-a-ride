class SearchController < ApplicationController
  def search_rides
    origin = params[:origin] 
    dest = params[:dest]
    matcher = params[:matcher]
    results = User.send "find_matches_for_#{matcher}"
    @paginated_results = results.paginate(:page => params[:page], :per_page => 5)
    respond_to do |format|
      format.html { render :partial => 'search_results' }
    end
  end
end
