FROM pinglamb/nginx-docker:0.9.19
MAINTAINER tennison.chan+dockerfile-gist@gmail.com

# Extra Dependencies
RUN apt-get update && \
  apt-get install -y libpq-dev nodejs && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Mount the following volume to external
VOLUME ["/home/app/log", "/home/app/public/assets", "/home/app/public/tmp/cache"]

ENV RAILS_ENV production
WORKDIR /home/app

# The freeze folder is to cache and avoid the bundle from scratch everytime
# The ordering of the following commands lines matters
ADD docker/freeze/Gemfile /home/app/Gemfile
ADD docker/freeze/Gemfile.lock /home/app/Gemfile.lock
RUN bundle install --binstubs --deployment --without development test --jobs 2
ADD Gemfile /home/app/Gemfile
ADD Gemfile.lock /home/app/Gemfile.lock
RUN bundle install --binstubs --deployment --without development test --jobs 2

RUN unlink /etc/nginx/sites-enabled/default
ADD docker/nginx-app.conf /etc/nginx/sites-enabled/app.conf
ADD docker/nginx-env.conf /etc/nginx/main.d/nginx-env.conf

# Init Scripts
RUN mkdir -p /etc/my_init.d
# Change permission to make sure using app user instead of root
ADD docker/init/01_permissions /etc/my_init.d/01_permissions
ADD docker/init/02_assets /etc/my_init.d/02_assets
RUN chmod +x /etc/my_init.d/*

# The runit service is to make it auto-restart the services after it stopped
RUN mkdir /etc/service/puma
ADD docker/runit/puma /etc/service/puma/run
RUN chmod +x /etc/service/puma/run
RUN mkdir /etc/service/sidekiq
ADD docker/runit/sidekiq /etc/service/sidekiq/run
RUN chmod +x /etc/service/sidekiq/run

ADD config.ru /home/app/config.ru
ADD Rakefile /home/app/Rakefile
ADD bin /home/app/bin
ADD public /home/app/public
ADD lib /home/app/lib
ADD vendor /home/app/vendor
ADD db /home/app/db
ADD config /home/app/config
ADD docker/database.yml /home/app/config/database.yml
ADD docker/redis.yml config/redis.yml
# ADD docker/elasticsearch.yml /home/app/config/elasticsearch.yml
ADD app /home/app/app