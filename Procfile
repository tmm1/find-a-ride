web: bundle exec thin start -p $PORT -e $RACK_ENV
worker: INTERVAL=10 QUEUE=emails bundle exec rake resque:work RAILS_ENV=$RACK_ENV