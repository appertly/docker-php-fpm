# docker-php-fpm
Docker image of PHP-FPM.

## Memcached Session Support
You can enable the `memcached` session handler at runtime by either using a Docker `--link` to a container running Memcached, or you can supply a list of servers in an environment variable. When PHP-FPM starts, the settings will be written to `/etc/php/7.1/fpm/php.ini` to enable Memcached based session storage. (If neither is used, standard file-based session storage remains the default.)

### Linked Docker Containers
You may link a Memcached container using the name `memcached`.
```bash
docker run -d --name foobar memcached
docker run -d --link foobar:memcached appertly/php-fpm
```
### Environment variable
You may pass the `MEMCACHED` environment variable which should contain a list of Memcached hosts and ports.
```bash
docker run -d -e "MEMCACHED=192.168.0.50:11211,192.168.0.60:11211" appertly/php-fpm
```

## CA Certificates
You can mount a volume to `/usr/local/share/ca-certificates` that contains any certificate authorities you wish to accept as trusted. Debian's `update-ca-certificates` is run before PHP-FPM executes.
