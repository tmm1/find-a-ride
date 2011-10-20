class User < ActiveRecord::Base
  include ActiveModel::Validations
  
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_attached_file :photo, :styles => { :thumb => "100x100>" },
    :storage => :s3,
    :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
    :path => "/:style/:id/:filename"

  has_many :offered_rides, :class_name => 'Ride', :foreign_key => 'offerer_id'
  has_many :shared_rides, :class_name => 'Ride', :foreign_key => 'sharer_id'

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :mobile, :landline, :driver, :rider, :first_name, :last_name, :origin, :destination,
    :terms, :photo, :photo_content_type, :photo_file_size, :inactive

  devise :omniauthable

  validates :first_name, :last_name, :presence => true
  validates :origin, :destination, :presence => true, :on => :update
  validates :mobile, :landline, :format => { :with => /^\d{10}$/, :allow_blank => true}
  validates_inclusion_of :origin, :destination, :in => APP_LOCATIONS["Hyderabad"], :message => "entered is not recognized by our system.", :on => :update
  validates :terms, :acceptance => true, :on => :create
  validates_attachment_content_type :photo, :content_type => %w(image/jpeg image/jpg image/png image/gif), :message => 'must be of type jpeg, png or gif', :if => :photo_attached?
  validates_attachment_size :photo, :less_than => 3.megabytes, :message => 'cannot be greater than 3 MB', :if => :photo_attached?
  validates :rider, :rider_driver => true, :on => :update

  before_validation :rewrite_location_attributes

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
  
  def self.find_matches_for_drivers(origin = '', dest = '', current_user=nil)
    if current_user
      items_table = Arel::Table.new(:users)
      users_without_current = User.where(items_table[:id].not_in current_user.id)
      User.where(:driver => true, :origin.downcase => origin.downcase, :destination.downcase => dest.downcase, :inactive => false, :id => users_without_current)
    else
      User.where(:driver => true, :origin.downcase => origin.downcase, :destination.downcase => dest.downcase, :inactive => false)
    end
  end
  
  def self.find_matches_for_riders(origin = '', dest = '', current_user=nil)
    if current_user
      items_table = Arel::Table.new(:users)
      users_without_current = User.where(items_table[:id].not_in [current_user.id])
      User.where(:rider => true, :origin.downcase => origin.downcase, :destination.downcase => dest.downcase, :inactive => false, :id => users_without_current)
    else
      User.where(:rider => true, :origin.downcase => origin.downcase, :destination.downcase => dest.downcase, :inactive => false)
    end
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
  
  def ext_attributes
    self.attributes.merge({"name" => self.name, "phone" => self.phone})
  end
  
  def phone
    self.mobile || self.landline
  end
  
  private
  
  def rewrite_location_attributes
    self.origin = self.origin.try(:downcase).try(:titleize)
    self.destination = self.destination.try(:downcase).try(:titleize)
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
#  driver                 :boolean(1)
#  rider                  :boolean(1)
#  mobile                 :string(255)
#  landline               :string(255)
#  origin                 :string(255)
#  destination            :string(255)
#  photo_file_name        :string(255)
#  photo_content_type     :string(255)
#  photo_file_size        :integer(4)
#  photo_updated_at       :datetime
#  inactive               :boolean(1)      default(FALSE)
#

