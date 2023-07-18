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
     cp -r /var/www/PicoCMS/content-sample/* /var/www/html/content/
fi

if [ -n "$allow_php_status_ip" ]
then
  sed -e "s!127.0.0.2!$allow_php_status_ip!" /config/nginx_site.conf > /etc/nginx/http.d/default.conf
fi

if [ -n "$allow_php_ping_ip" ]
then
  sed -e "s!127.0.0.3!$allow_php_ping_ip!"  /config/nginx_site.conf > /etc/nginx/http.d/default.conf
fi

if [ -n "$php_ping_text" ]
then
  sed -e "s/pong/$php_ping_text/" /config/php_fpm_site.conf > /etc/php81/php-fpm.d/www.conf
fi

ln -s /dev/stdout /var/log/fpm-php.www.log
ln -s /dev/stdout /var/log/nginx/access.log

php-fpm81

exec "$@"
