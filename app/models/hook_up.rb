class HookUp < ActiveRecord::Base 
  belongs_to :contacter, :class_name => 'User'
  belongs_to :contactee, :class_name => 'User'
  belongs_to :hookable, :polymorphic => true

  attr_accessor :mobile
  
  after_create :email_notification

  validates :contactee_id, :contacter_id, :message, :hookable_id, :hookable_type, :presence => true
  validates :mobile, :format => { :with => /^[1-9]+\d{9}$/, :allow_blank => true}
  
  def email_notification
    if self.hookable_type == "RideRequest"
      HookupMailer.ride_offerer_email(self,self.mobile).deliver
    else
      HookupMailer.ride_requestor_email(self,self.mobile).deliver
    end
  end
  
end


# == Schema Information
#
# Table name: hook_ups
#
#  id            :integer(4)      not null, primary key
#  contactee_id  :integer(4)
#  contacter_id  :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  message       :string(3000)
#  hookable_id   :integer
#  hookable_type :string
#

