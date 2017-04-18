FROM ubuntu:xenial
MAINTAINER Jonathan Hawk <jonathan@appertly.com>

# Install php
RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git \
        php7.1-fpm php7.1-cli php7.1-opcache php7.1-gd php7.1-gmp php7.1-mcrypt php-imagick php7.1-mbstring php7.1-intl \
        php-memcached php7.1-mysql php7.1-pgsql php7.1-sqlite3 php7.1-curl php7.1-xml php7.1-zip php7.1-mongodb \
        php7.1-soap php7.1-xmlrpc \
    && sed -i 's/^/#/' /etc/cron.d/php \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/log/apt/* \
    && rm -rf /var/log/dpkg.log \
    && rm -rf /var/log/bootstrap.log \
    && rm -rf /var/log/alternatives.log

# error logs to docker log collector
RUN ln -sf /dev/stderr /var/log/php7.1-fpm.log \
    && mkdir -p /run/php \
    && echo "1" > /run/php/php7.1-fpm.pid

ADD php.ini /etc/php/7.1/fpm/php.ini
ADD www.conf /etc/php/7.1/fpm/pool.d/www.conf
ADD start.sh /scripts/start.sh
RUN chmod +x /scripts/start.sh

# PHP-FPM on FastCGI with default port of 9000
EXPOSE 9000

# Default command
CMD ["/scripts/start.sh"]
