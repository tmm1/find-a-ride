web: bundle exec thin start -p $PORT -e $RACK_ENV
worker: VVERBOSE=true INTERVAL=8 QUEUE=emails bundle exec rake resque:work RAILS_ENV=$RACK_ENV
