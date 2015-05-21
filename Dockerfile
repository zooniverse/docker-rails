FROM ubuntu:12.04

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y -q install apt-transport-https ca-certificates && \
    echo "deb https://oss-binaries.phusionpassenger.com/apt/passenger/4 precise main" >> /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y -q install nginx-extras passenger supervisor logrotate && \
    mkdir -p /var/log/supervisor && \
    rm /etc/nginx/sites-enabled/default /etc/logrotate.d/nginx

ADD image-fs/ /

VOLUME ["/var/log/nginx", "/var/log/supervisor", "/rails/log/"]

EXPOSE 80
ENTRYPOINT ["./opt/start_nginx_rails.sh"]

ENV RACK_ENV production
ENV RAILS_ENV production
