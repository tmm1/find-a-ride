class User < ActiveRecord::Base
  include ActiveModel::Validations
  
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :ride_offers
  has_many :ride_requests
  has_many :hook_ups_as_contacter, :class_name => 'HookUp', :foreign_key => 'contacter_id'
  has_many :hook_ups_as_contactee, :class_name => 'HookUp', :foreign_key => 'contactee_id'

  attr_accessor :mobile_required

  has_attached_file :photo, 
                    :styles => { :thumb => "100x100#" },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
                    :path => "/:style/:id/:filename"

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :mobile, :landline, :first_name, :last_name, :terms, :photo, :photo_content_type, :photo_file_size, :inactive, :mobile_required

  devise :omniauthable

  validates :first_name, :last_name , :presence => true
  validates :mobile , :presence => true,  :if => Proc.new {|user| user.mobile_required == 'true'}
  validates :landline, :format => { :with => /^\d{10}$/, :allow_blank => true}
  validates :mobile, :format => { :with => /^[1-9]\d{9}$/, :allow_blank => true}
  validates :terms, :acceptance => true, :on => :create
  validates_attachment_content_type :photo, :content_type => %w(image/jpeg image/jpg image/png image/gif), :message => 'must be of type jpeg, png or gif', :if => :photo_attached?
  validates_attachment_size :photo, :less_than => 3.megabytes, :message => 'cannot be greater than 3 MB', :if => :photo_attached?

  def update_with_password(params={})
    if params[:password].blank?
      self.update_without_password(params)
    elsif !params[:password].blank? || !params[:password_confirmation].blank?
      self.update_attributes(params)
    end
  end
  
  def full_name
    "#{self.first_name.capitalize} #{self.last_name.capitalize}"
  end
  
  alias_method :name, :full_name
  
  def active?
    !self.inactive
  end
  
  def self.active
    where(:inactive => false)
  end
  
  def aggregrated_hook_ups(limit=5)
    (self.hook_ups_as_contacter.order('created_at DESC') + self.hook_ups_as_contactee.order('created_at DESC')).sort_by(&:created_at).reverse.first(limit)
  end
  
  def hooked_up_for_ride?(ride)
    self.hook_ups_as_contacter.unclosed.collect{|h| h.hookable_id}.include?(ride.id) || self.hook_ups_as_contactee.unclosed.collect{|h| h.hookable_id}.include?(ride.id) 
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)    
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else
      a = User.create(:email => data["email"], :password => "changeme!", :first_name => data["first_name"], :last_name => data["last_name"])
      return a
    end
  end

  def self.find_for_twitter_oauth(email, first_name, last_name, signed_in_resource=nil)    
    if user = User.find_by_email(email)
      user
    else 
      a = User.create(:email => email, :password => "changeme!", :first_name => first_name, :last_name => last_name)
      return a
    end
  end

  def photo_attached?
    self.photo.file?
  end
  
  def phone
    self.mobile || self.landline
  end
end





# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  last_name              :string(255)
#  mobile                 :string(255)
#  landline               :string(255)
#  photo_file_name        :string(255)
#  photo_content_type     :string(255)
#  photo_file_size        :integer(4)
#  photo_updated_at       :datetime
#  inactive               :boolean(1)      default(FALSE)
#

