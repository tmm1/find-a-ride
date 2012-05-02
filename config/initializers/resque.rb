RESQUE_CONFIG = YAML.load_file(File.join(Rails.root, '/config/resque.yml'))
Resque.redis = RESQUE_CONFIG[Rails.env]
