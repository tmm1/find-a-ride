class HookUpsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @contactee = User.find_by_id(params[:id]) if params[:id]
    @origin = params[:orig]
    @dest = params[:dest]
    @time = params[:time]
    @hook = HookUp.new
    render :layout => false
  end

  def create
    @hook_up = HookUp.new(params[:hook_up])
    mobile = params[:hook_up][:mobile]
    type = params[:hook_up][:ride_type]
    if @hook_up.save
      if type == "ride_request"
        HookupMailer.ride_offerer_email(@hook_up,mobile).deliver
       else
        HookupMailer.ride_requestor_email(@hook_up,mobile).deliver
      end
      render :text => 'success', :status => 200
    else
      render :text => 'failed', :status => 200
    end
  end

end
