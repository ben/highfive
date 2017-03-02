web: bundle exec puma -e $RAILS_ENV -S ~/puma -C config/puma.rb
worker: bundle exec rake resque:work QUEUE='*' VERBOSE=1
