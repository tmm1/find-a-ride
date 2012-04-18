class Alert < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User'
  
  state_machine :state, :initial => :unread do
    event :read do
      transition :unread => :read
    end 
  end
end

# == Schema Information
#
# Table name: alerts
#
#  id          :integer(4)      not null, primary key
#  sender_id   :integer(4)
#  receiver_id :integer(4)
#  state       :string(255)
#  message     :string(5000)
#  created_at  :datetime
#  updated_at  :datetime
#

