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
   @hookable = find_hookable
   @hook_up = @hookable.hook_ups.build(params[:hook_up]) if @hookable
   if @hookable && @hook_up.save
      render :text => 'success', :status => 200
    else
      render :text => 'failed', :status => 200
    end
  end

 def find_hookable
  params.each do |name, value|
    if name =~ /(.+)_id$/
      return $1.classify.constantize.find(value)
    end
  end
   nil
 end

end
