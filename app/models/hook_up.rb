class HookUp < ActiveRecord::Base 
  belongs_to :contacter, :class_name => 'User'
  belongs_to :contactee, :class_name => 'User'
  attr_accessor :phone_number

  validates :contactee_id, :contacter_id, :message, :presence => true
  validates :phone_number, :format => { :with => /^[1-9]+\d{9}$/, :allow_blank => true}
end


# == Schema Information
#
# Table name: hook_ups
#
#  id           :integer(4)      not null, primary key
#  contactee_id :integer(4)
#  contacter_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  message      :string(3000)
#

