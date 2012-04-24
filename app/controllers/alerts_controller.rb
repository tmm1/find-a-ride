class AlertsController < ApplicationController
  before_filter :authenticate_user!
  
  authorize_resource
  
  def index
    @alerts = current_user.received_alerts.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end
end
