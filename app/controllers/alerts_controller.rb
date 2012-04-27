class AlertsController < ApplicationController
  before_filter :authenticate_user!
  
  authorize_resource
  
  def index
    get_alerts
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

  def archive
    alert = Alert.find_by_id(params[:id])
    if alert and alert.archive
      flash.now[:success] = "The alert was archived successfully"
    else
      flash.now[:error] = "The alert was not archived"
    end

    get_alerts
    respond_to do |wants|
      wants.js { render :action => :index }
    end
  end

  private

  def get_alerts
    @alerts = current_user.received_alerts.unarchived.order('created_at DESC').paginate(:page => params[:page], :per_page => 3)
  end
end
