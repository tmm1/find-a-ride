def run(*cmd)
  system(*cmd)
  raise "Command #{cmd.inspect} failed!" unless $?.success?
end

def confirm(message)
  print "\n#{message}\nAre you sure? [yn] "
  raise 'Aborted' unless STDIN.gets.chomp == 'y'
end

namespace :deploy do
  PRODUCTION_APP = 'find-a-ride'
  PRODUCTION_BUNDLE = 'find-a-ride-bundle'
  desc "Deploy to Production"
  task :production do
    iso_date = Time.now.strftime('%Y-%m-%dT%H%M%S')

    confirm('This will deploy Find-a-Ride to production. Are you sure?')

    tag_name = "heroku-#{iso_date}"
    puts "\n Tagging as #{tag_name}..."
    run "git tag #{tag_name} master"

    puts "\n Pushing..."
    run "git push origin #{tag_name}"
    run "git push git@heroku.com:#{PRODUCTION_APP}.git #{tag_name}:master"

    puts "\n Migrating..."
    run "heroku rake db:migrate --app #{PRODUCTION_APP}"
    run "heroku rake db:seed --app #{PRODUCTION_APP}"

    puts "\n Deployment process completed"
  end
end

namespace :db do
  PRODUCTION_APP = 'find-a-ride'
  desc 'Migrate and Seed the Production Database'
  task :production  do
    confirm('This will drop, migrate and seed your production database. Are you sure?')
    run "heroku pg:reset SHARED_DATABASE_URL --confirm #{PRODUCTION_APP}"
    run "heroku rake db:migrate --app #{PRODUCTION_APP}"
    run "heroku rake db:seed --app #{PRODUCTION_APP}"
    puts "\n migrations ran completely"
  end
end





