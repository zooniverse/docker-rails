FROM zooniverse/passenger

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y -q install build-essential ruby1.9.1 ruby1.9.1-dev imagemagick libsqlite3-dev libmagickwand-dev libcurl3 libxml2 libxslt1-dev libcurl4-gnutls-dev git-core mysql-client libmysqlclient-dev && \
    gem install bundler
