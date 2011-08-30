class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!,:except => [:auto_search]
  
  
  def auto_search
    @result = (APP_LOCATIONS.map do |l|
        l if l.to_s.match(params[:q].to_s.titleize)
      end).compact
    respond_to do |wants|
      wants.json {
        render :json => @result
      }
    end
  end
end
