class Alert < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User'
  belongs_to :hook_up
  
  validates :hook_up_id, :sender_id, :receiver_id, :presence => true
  
  after_create :generate_pusher_notification
  
  state_machine :state, :initial => :unread do
    event :read do
      transition :unread => :read
    end
    event :archive do
      transition :read => :archived
    end 
  end
  
  def self.read
    where(:state => 'read')
  end
  
  def self.unread
    where(:state => 'unread')
  end
  
  def self.unarchived
    where("alerts.state != ?", 'archived')
  end
  
  private
  
  def generate_pusher_notification
    begin
      Pusher[PUSHER_CHANNEL].trigger!(PUSHER_EVENT, {:user_id => self.receiver.id.to_s, :message => self.receiver.unread_alerts.size})
    rescue Pusher::Error => ex
      Rails.logger.error "#{ex.message}: #{ex.backtrace}"
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

