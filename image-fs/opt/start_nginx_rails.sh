#!/bin/bash -x

set -e

usage() {
    echo -e "
    usage: $0 options

    Configures and starts a rails app behind nginx and passenger

    OPTIONS:
      -h Print this message
      -l=PATH Path to Symlink config files (empty and ignored by default)
      -p Precompile Assets (false by default)
    "
}

CONFIG_PATH=
PRECOMPILE=false

while getopts "hpl:" OPTION
do
  case $OPTION in
    h)
      usage
      exit 1
      ;;
    p)
      PRECOMPILE=true
      ;;
    l)
      CONFIG_PATH=$OPTARG
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done

SECRETS_ENV_FILE=${SECRETS_ENV_FILE:-/run/secrets/environment}
[ -f $SECRETS_ENV_FILE ] && eval $(sed 's/^/export /' $SECRETS_ENV_FILE)

if [[ -n $CONFIG_PATH ]];
then
  if [[ "$CONFIG_PATH" != */ ]]; 
  then
    CONFIG_PATH="$CONFIG_PATH/"
  fi

  ln -sf $CONFIG_PATH*.yml /rails/config/
fi

if [ "$PRECOMPILE" = true ];
then
  cd /rails
  bundle exec rake assets:precompile
fi

if [ -f /rails/log/production.log ]
then
    rm /rails/log/production.log
fi
mkdir -p /rails/log/
ln -s /dev/stdout /rails/log/production.log

chown -R www-data:www-data /rails

exec /usr/bin/supervisord
