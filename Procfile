
web: bin/rails server -p ${PORT:-5000} -e $RAILS_ENV

worker: bundle exec sidekiq -c 1 -q default -q mailers 

