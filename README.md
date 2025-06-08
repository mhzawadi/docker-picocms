Pico [![Latest image](https://github.com/mhzawadi/docker-picocms/actions/workflows/image-latest.yml/badge.svg)](https://github.com/mhzawadi/docker-picocms/actions/workflows/image-latest.yml)
====

Pico is a stupidly simple, blazing fast, flat file CMS.

Visit us at http://picocms.org/ and see http://picocms.org/about/ for more info.

Screenshot
----------

![Pico Screenshot](https://picocms.github.io/screenshots/pico-21.png)

## Install

The below will start the container with port 8080 exposed,
the 4 paths containing the site

```bash
docker run --name picocms \
  -p 8080:80 \
  -v /my_dir/picocms_assets:/var/www/html/assets \
  -v /my_dir/picocms_config:/var/www/html/config \
  -v /my_dir/picocms_content:/var/www/html/content \
  -v /my_dir/picocms_plugins:/var/www/html/plugins \
  -v /my_dir/picocms_themes:/var/www/html/themes\ 
  -d mhzawadi/picocms
```

## PHP timezone
- php_timezone: the PHP timezone

## New php monitoring

This will now expose both the ping and status pages from FPM,
you will need set an allowed IP for both pages.

The endpoints are `/php_status` and `/php_ping`

- allow_php_status_ip: this is an IP addres that can see the status page
- allow_php_ping_ip: this is an IP addres that can see the ping/pong page
- php_ping_text: the text that should be returned by the ping page

```bash
docker run --name picocms \
  -p 8080:80 \
  -v /my_dir/picocms_assets:/var/www/html/assets \
  -v /my_dir/picocms_config:/var/www/html/config \
  -v /my_dir/picocms_content:/var/www/html/content \
  -v /my_dir/picocms_plugins:/var/www/html/plugins \
  -v /my_dir/picocms_themes:/var/www/html/themes \
  -e 'allow_php_status_ip=1.2.3.4' \
  -e 'allow_php_ping_ip=1.2.3.4' \
  -e 'php_ping_text=this is a pong' \
  -d mhzawadi/picocms
```
