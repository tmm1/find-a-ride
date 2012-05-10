# Load the rails application
require File.expand_path('../application', __FILE__)


# Initialize the rails application
PoolRide::Application.initialize!

# Feedback email for the app
ADMIN_EMAIL = 'karthik.m@imaginea.com'

# Pusher settings
Pusher.app_id = '18946'
Pusher.key = 'da814fcf509ac142465a'
Pusher.secret = '1a28fbe1721cc21a9f33'
Pusher.logger = Rails.logger
PusherClient.logger = Rails.logger

#admin password
ADMIN_PASSWORD = '0nTheW@y@dm1n' #TODO: store this as a simple encrypted hash and not clear text