#!/bin/sh
set -e

source /etc/profile
mkdir -p /data/conf/nginx /data/www /data/logs /data/tmp/php /data/tmp/nginx
chown -R www:www /data/tmp /data/logs
chown www:www /data/www

exec "$@"
