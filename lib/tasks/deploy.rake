def run(*cmd)
  system(*cmd)
  raise "Command #{cmd.inspect} failed!" unless $?.success?
end

def confirm(message)
  print "\n#{message}\nAre you sure? [yn] "
  raise 'Aborted' unless STDIN.gets.chomp == 'y'
end

namespace :deploy do
  STAGING_APP = 'on-the-way'
  STAGING_WORKER = 'on-the-way-worker'
  STAGING_BUNDLE = 'on-the-way-bundle'
  desc "Deploy to Staging"
  task :staging do
    iso_date = Time.now.strftime('%Y-%m-%dT%H%M%S')

    confirm('This will deploy OnTheWay to staging. Are you sure?')

    tag_name = "heroku-#{iso_date}"
    puts "\n Tagging as #{tag_name}..."
    run "git tag #{tag_name} master"
    run "git push origin #{tag_name}"
    
    puts "\n Pushing web app..."
    run "git push heroku #{tag_name}:master"
    puts "\n Pushing worker app..."
    run "git push worker #{tag_name}"

    puts "\n Migrating..."
    run "heroku run rake db:migrate --app #{STAGING_APP}"

    puts "\n Seeding..."
    run "heroku run rake db:seed --app #{STAGING_APP}"

    puts "\n Deployment to staging completed"
  end
end

namespace :db do
  PRODUCTION_APP = 'on-the-way'
  desc 'Migrate and Seed the staging database'
  task :staging  do
    confirm('This will drop, migrate and seed your staging database. Are you sure?')
    run "heroku pg:reset SHARED_DATABASE_URL --confirm #{STAGING_APP}"
    run "heroku run rake db:migrate --app #{STAGING_APP}"
    run "heroku run rake db:seed --app #{STAGING_APP}"
    puts "\n migrations ran completely"
  end
end





