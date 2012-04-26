class AlertsController < ApplicationController
  before_filter :authenticate_user!
  
  authorize_resource
  
  def index
    @alerts = current_user.received_alerts.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end

  def read
    begin
      alert = Alert.find(params[:id])
      status = alert.read ? 'success' : 'failure'
    rescue
      status = 'failure'
    end
    respond_to do |wants|
      wants.json { render :json => { :status => status } }
    end
  end
end
