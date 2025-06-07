FROM alpine:3.22
LABEL org.opencontainers.image.authors="Matthew Horwood <matt@horwood.biz>"

# Install required apk packages
RUN apk update && \
	apk add nginx curl alpine-conf \
	&& setup-apkrepos -o \
	&& apk add php84-fpm php84-mbstring php84-dom composer \
	&& mkdir -p /var/www/html/ \
	&& mkdir -p /run/nginx \
	&& rm -f /var/cache/apk/*;

ENV SSL="false"

COPY config /config

ENV PICO_SOURCE="https://github.com/picocms/Pico/releases/download" \
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
    cp /config/php.ini /etc/php84/php.ini && \
		cp /config/php_fpm_site.conf /etc/php84/php-fpm.d/www.conf && \
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
