class HooksController < ApplicationController
  before_filter :authenticate_user!

  def new
    @contactee = User.find_by_id(params[:id]) if params[:id]
    @hook = HookUp.new
    render :layout => false
  end

  def create
   @hook = HookUp.new(params[:hook_up])
    if @hook.save
      render :text => 'success', :status => 200
    else
      render :text => 'failed', :status => 200
    end
  end

end
