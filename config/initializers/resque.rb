require 'resque/server'
RESQUE_CONFIG = YAML.load_file(File.join(Rails.root, '/config/resque.yml'))
Resque.redis = RESQUE_CONFIG[Rails.env]
Resque::Server.use(Rack::Auth::Basic) do |user, password|
  user == 'admin'
  password == ADMIN_PASSWORD
end
