class AlertsController < ApplicationController
  before_filter :authenticate_user!
  
  authorize_resource
  
  def index
    @alerts = current_user.received_alerts.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end

  def read
    alert = Alert.find(params[:id])
    if alert.read  
      respond_to do |wants|
        wants.json { render :json => { :status => 'success' } }
      end    
    else
      respond_to do |wants|
        wants.json { render :json => { :status => 'failure' } }
      end    
    end
  end
end
