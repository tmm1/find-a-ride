class HomeController < ApplicationController
  def about
  end
  
  def index
    if user_signed_in?
      redirect_to rides_path
    end
  end
  
  def remove_fav_location
    @user = current_user
    user_location_id = params[:id].split('_').last
    UserLocation.delete(user_location_id) if user_location_id
    respond_to do |format|
      format.js {
        render 'remove_location'
      }
    end
  end
end
