class ApplicationController < ActionController::Base
  protect_from_forgery
  include Geokit::Geocoders
  helper_method :selected_city
  before_filter :authenticate_user!, :only => [:admin, :authorize_admin]

  def location_search    
    @result = (City.find_by_name(selected_city).locations.select("name").collect {|loc| loc.name.downcase}.map do |l|
      l.titleize if l.to_s.match(params[:q].to_s.try(:downcase))
    end).compact
    respond_to do |wants|
      wants.json { render :json => @result }
    end
  end

  def geocode_city
    values = params[:lat_long].gsub("(","").gsub(")", "").split(",")
    res = GoogleGeocoder.reverse_geocode([values[0] , values[1]])
    values = res.full_address.split(",")
    session[:city] = values[-3].strip
    render :text => "success" , :status => 200
  end

  def restrict_inactive_user
    redirect_to inactive_home_index_path unless current_user.active?
  end

  def initialize_city
    cookies[:city] = params[:city] unless params[:city].nil?
    session[:city] = cookies[:city]
    redirect_to root_path, :notice => "You have chosen #{session[:city]}"
  end

  def selected_city
    session[:city] || cookies[:city] || 'Hyderabad'
  end

  def admin
    render 'home/admin'
  end

  def authorize_admin
    if params[:admin_password].eql? ADMIN_PASSWORD
      flash[:success] = 'Thanks for authenticating'
      session[:admin_authenticated] = true
      redirect_to "#{root_path}resque"
    else
      respond_to do |format|
        flash.now[:error] = 'Sorry! That was not the right password'
        format.html { render 'home/admin' }
      end
    end
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    set_flash_message :notice, :signed_out
    root_path
  end
end
