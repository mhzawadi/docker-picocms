FROM alpine:3.21.0
MAINTAINER Matthew Horwood <matt@horwood.biz>

# Install required deb packages
RUN apk update && \
	apk add nginx php81-fpm php81-mbstring php81-dom composer curl \
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

ENV PICO_SOURCE="https://github.com/picocms/Pico/releases/download/" \
		PICO_SEMVER="3.0.0-alpha.2" \
		PICO_VERSION="v3.0.0-alpha.2"

# copy phpipam sources to web dir
ADD ${PICO_SOURCE}/${PICO_VERSION}/pico-release-${PICO_VERSION}.tar.gz /var/www/
ADD https://github.com/picocms/Pico/archive/refs/tags/${PICO_VERSION}.zip /var/www/
RUN cd /var/www && \
		unzip "${PICO_VERSION}.zip" && \
		mv Pico-${PICO_SEMVER} PicoCMS && \
		cd html && \
    tar xf ../pico-release-${PICO_VERSION}.tar.gz && \
    cp /config/php.ini /etc/php81/php.ini && \
		cp /config/php_fpm_site.conf /etc/php81/php-fpm.d/www.conf && \
    cp /config/nginx_site.conf /etc/nginx/http.d/default.conf;

VOLUME /var/www/html/content
VOLUME /var/www/html/themes
VOLUME /var/www/html/plugins
VOLUME /var/www/html/config

EXPOSE 80
ENTRYPOINT ["/config/start.sh"]
CMD ["nginx", "-g", "daemon off;"]

## Health Check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD curl -f http://127.0.0.1/index.php || exit 1
