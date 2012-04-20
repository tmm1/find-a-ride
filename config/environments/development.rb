PoolRide::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :letter_opener
  
  Paperclip.options[:command_path] = '/usr/local/bin/identify'
  
  PUSHER_CHANNEL = 'ontheway_dev'
  PUSHER_EVENT = 'user_alert_dev'
  
  FACEBOOK_DIRECT_URL = 'https://www.facebook.com/dialog/apprequests?app_id=250325615010342&message=Invitation%20to%20join%20OnTheWay%20app!&redirect_uri=http://localhost:3000/facebook_invite'
end

