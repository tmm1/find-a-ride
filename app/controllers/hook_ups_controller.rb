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
   if @hook_up.save
      render :text => 'success', :status => 200
    else
      render :text => 'failed', :status => 200
    end
  end
end