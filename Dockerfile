FROM ubuntu:xenial
MAINTAINER Jonathan Hawk <jonathan@appertly.com>

# Install php
RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git \
        php5.6-fpm php5.6-cli php5.6-gd php5.6-gmp php5.6-mcrypt php-imagick php5.6-mbstring php5.6-intl \
        php5.6-ldap php5.6-mcrypt \
        php-memcached php5.6-mysql php5.6-pgsql php5.6-sqlite3 php5.6-curl php5.6-xml php5.6-zip php5.6-mongodb \
    && sed -i 's/^/#/' /etc/cron.d/php \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/log/apt/* \
    && rm -rf /var/log/dpkg.log \
    && rm -rf /var/log/bootstrap.log \
    && rm -rf /var/log/alternatives.log

# error logs to docker log collector
RUN ln -sf /dev/stderr /var/log/php5.6-fpm.log \
    && mkdir -p /run/php \
    && echo "1" > /run/php/php5.6-fpm.pid

ADD php.ini /etc/php/5.6/fpm/php.ini
ADD www.conf /etc/php/5.6/fpm/pool.d/www.conf
ADD start.sh /scripts/start.sh
RUN chmod +x /scripts/start.sh

# PHP-FPM on FastCGI with default port of 9000
EXPOSE 9000

# Default command
CMD ["/scripts/start.sh"]
