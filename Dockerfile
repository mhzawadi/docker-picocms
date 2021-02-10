FROM alpine:3.13
MAINTAINER Matthew Horwood <matt@horwood.biz>

# Install required deb packages
RUN apk update && \
	apk add nginx php7-fpm php7-mbstring php7-dom composer curl \
	&& mkdir -p /var/www/html/ \
	&& mkdir -p /run/nginx \
	&& rm -f /var/cache/apk/*;

ENV SSL="false" \
    SSL_KEY="/path/to/cert.key" \
    SSL_CERT="/path/to/cert.crt" \
    SSL_CA="/path/to/ca.crt" \
    SSL_CAPATH="/path/to/ca_certs" \
    SSL_CIPHER="DHE-RSA-AES256-SHA:AES128-SHA"

COPY config /config

# copy phpipam sources to web dir
RUN cd /var/www/html \
    php composer.phar create-project picocms/pico-composer pico && \
    cp /config/php.ini /etc/php7/php.ini && \
		cp /config/php_fpm_site.conf /etc/php7/php-fpm.d/www.conf && \
    cp /config/nginx_site.conf /etc/nginx/conf.d/default.conf;


EXPOSE 80
ENTRYPOINT ["/config/start.sh"]
CMD ["nginx", "-g", "daemon off;"]

## Health Check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD curl -f http://127.0.0.1/index.php || exit 1