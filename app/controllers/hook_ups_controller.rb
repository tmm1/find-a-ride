class HookUpsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @contactee = User.find_by_id(params[:id]) if params[:id]
    @hook = HookUp.new
    render :layout => false
  end

  def create
   @hook = HookUp.new(params[:hook_up])
   mobile = params[:hook_up][:mobile]
   type = params[:hook_up][:ride_type]
    if @hook.save
      if type == "ride_request"
        HookupMailer.ride_offer_email(@hook,mobile).deliver
       else
        HookupMailer.ride_request_email(@hook,mobile).deliver
      end
      render :text => 'success', :status => 200
    else
      render :text => 'failed', :status => 200
    end
  end

end
