class SearchController < ApplicationController
  def search_rides
    origin = params[:origin] 
    dest = params[:dest]
    matcher = params[:matcher]
    @results = User.send "find_matches_for_#{matcher}"
    respond_to do |format|
      format.html { render :partial => 'search_results' }
    end
  end
end
