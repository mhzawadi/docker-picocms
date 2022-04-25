#!/bin/sh

# Make sure the default stuff is there
if [ ! -f /var/www/html/config/config.yml.template ]
then
    tar -xzf /var/www/pico-release-${PICO_VERSION}.tar.gz -C /var/www/html/config/ \
        --strip-components=1 config/config.yml.template
fi
if [ ! -d /var/www/html/plugins/PicoDeprecated/ ]
then
    tar -xzf /var/www/pico-release-${PICO_VERSION}.tar.gz -C /var/www/html/plugins/ \
        --strip-components=1 plugins/PicoDeprecated
fi
if [ ! -d /var/www/html/themes/default/ ]
then
    tar -xzf /var/www/pico-release-${PICO_VERSION}.tar.gz -C /var/www/html/themes/ \
        --strip-components=1 themes/default
fi
if [ ! -f /var/www/html/content/index.md ]
then
    tar -xzf /var/www/pico-release-${PICO_VERSION}.tar.gz -C /var/www/html/content/ \
        --strip-components=1 content-sample
fi

ln -s /dev/stdout /var/log/fpm-php.www.log
ln -s /dev/stdout /var/log/nginx/access.log

php-fpm7

exec "$@"
