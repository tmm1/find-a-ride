class HookUp < ActiveRecord::Base 

  default_scope lambda {
    joins("INNER JOIN rides ON rides.id = hook_ups.hookable_id").where("rides.expires_on >= ?", Date.today)
  }

  # DynamicDefaultScoping to be included after default_scope
  include DynamicDefaultScoping

  belongs_to :contacter, :class_name => 'User'
  belongs_to :contactee, :class_name => 'User'
  belongs_to :hookable, :polymorphic => true
  has_one :alert

  attr_accessor :mobile
  
  after_create :notify_contactee
  after_create :set_state
  after_create :create_alert

  validates :contactee_id, :contacter_id, :message, :hookable_id, :hookable_type, :presence => true
  validates :mobile, :format => { :with => /^[1-9]\d{9}$/, :allow_blank => true}
  
  scope :not_closed, where("state != ?", :closed)

  state_machine :state, :initial => :none do
    event :request do
      transition :none => :requested
    end 
    event :offer do
      transition :none => :offered
    end
    event :close do
      transition [:requested, :offered] => :closed
    end
  end
  
  def self.requested
    where(:state => 'requested')
  end
  
  def self.offered
    where(:state => 'offered')
  end
  
  def self.unclosed
    where(:state => ['requested', 'offered'])
  end
  
  private
  
  def set_state
    self.hookable.try(:request?) ? self.offer : self.request
  end
  
  def notify_contactee
    Resque.enqueue(HookupMailer, self.hookable.try(:request?) ? :ride_offerer_email : :ride_requestor_email, self.id, self.mobile)
  end
  
  def create_alert
    self.build_alert({:sender => self.contacter, :receiver => self.contactee, :message => self.message})
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
#  hookable_id   :integer(4)
#  hookable_type :string(255)
#  state         :string(255)
#

