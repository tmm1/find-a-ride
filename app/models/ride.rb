class Ride < ActiveRecord::Base
  belongs_to :offerer, :class_name => 'User', :foreign_key => 'offerer_id'
  belongs_to :sharer, :class_name => 'User', :foreign_key => 'sharer_id'
  
  serialize :user_info
  
  def self.create_ride(params)
    contactee = User.find(params[:contactee_id])
    if params[:contactor_id]
      contactor = User.find(params[:contactor_id])
    else
      user_info = params[:user_info]
    end
    # create ride
    if params[:matcher] == 'drivers'
      ride = Ride.create(:sharer => contactor, :offerer => contactee, :user_info => user_info, :contact_date => Time.now)
      UserMailer.contact_rider_email(ride, params[:message]).deliver
    elsif params[:matcher] == 'riders'
      ride = Ride.create(:sharer => contactee, :offerer => contactor, :user_info => user_info, :contact_date => Time.now)
      UserMailer.contact_driver_email(ride, params[:message]).deliver
    end
    ride
  end

  def humanized_user_info
    humanized = {}
    unless user_info.nil?
      user_info.keys.each {|k| humanized[k.to_s] = user_info[k]} 
    end
    humanized
  end
end

# == Schema Information
#
# Table name: rides
#
#  id           :integer(4)      not null, primary key
#  offerer_id   :integer(4)
#  sharer_id    :integer(4)
#  user_info    :string(1000)
#  contact_date :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

