class ApplicationController < ActionController::Base
  protect_from_forgery
  include Geokit::Geocoders
  
  def location_search    
    @result = (APP_LOCATIONS[params[:city]].collect {|loc| loc.downcase}.map do |l|
        l.titleize if l.to_s.match(params[:q].to_s.try(:downcase))
      end).compact
    respond_to do |wants|
      wants.json {
        render :json => @result
      }
    end
  end

  def geocode_city
    values = params[:lat_long].gsub("(","").gsub(")", "").split(",")
    res = GoogleGeocoder.reverse_geocode([values[0] , values[1]])
    values = res.full_address.split(",")
    session[:city] = values[-3].strip
    render :text => "success" , :status => 200
  end
end
