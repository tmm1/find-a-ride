class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :mobile, :landline, :driver, :rider, :first_name, :last_name, :origin, :destination,
    :terms

  devise :omniauthable

  validates :first_name, :last_name, :presence => true
  validates :mobile, :landline, :format => { :with => /^\d{10}$/, :allow_blank => true}
  validates_inclusion_of :origin, :destination, :in => APP_LOCATIONS, :allow_blank => true, :message => "entered is not recognized by our system."
  validates :terms, :acceptance => true, :on => :create

  before_validation :rewrite_location_attributes

  def update_with_password(params={})
    params.delete(:current_password)
    self.update_without_password(params)
  end
  
  def full_name
    "#{self.first_name.capitalize} #{self.last_name.capitalize}"
  end
  
  def self.find_matches_for_drivers(origin = '', dest = '')
    User.where(:driver => true, :origin.downcase => origin.downcase, :destination.downcase => dest.downcase)
  end
  
  def self.find_matches_for_riders(origin = '', dest = '')
    User.where(:rider => true, :origin.downcase => origin.downcase, :destination.downcase => dest.downcase)
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      a = User.create(:email => data["email"], :password => "welcome234",:first_name => data["first_name"],:last_name => data["last_name"])
      return a
    end
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
#

