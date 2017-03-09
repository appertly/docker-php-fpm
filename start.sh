#!/bin/bash

if [[ "$MEMCACHED_PORT" =~ ^tcp://[0-9]{1,3}(\.[0-9]{1,3}){3}:[0-9]+$ ]]
then
# Support Docker link to a memcached server
    sed -i "s/handler = files/handler = memcached/" /etc/php/7.1/fpm/php.ini
    sed -i "s/\/var\/lib\/php\/sessions/${MEMCACHED_PORT:6}/" /etc/php/7.1/fpm/php.ini
    echo "session.gc_probability = 0" >> /etc/php/7.1/fpm/php.ini
elif [ "$MEMCACHED" != "" ]
then
# Support environment variable with custom list of servers
    sed -i "s/handler = files/handler = memcached/" /etc/php/7.1/fpm/php.ini
    sed -i "s/\/var\/lib\/php\/sessions/$MEMCACHED/" /etc/php/7.1/fpm/php.ini
    echo "session.gc_probability = 0" >> /etc/php/7.1/fpm/php.ini
fi

update-ca-certificates

DAEMON=/usr/sbin/php-fpm7.1
ADDITIONAL_ARGS=""

DAEMON_ARGS="-F -c /etc/php/7.1/fpm/php.ini \
-y /etc/php/7.1/fpm/php-fpm.conf \
${ADDITIONAL_ARGS}"

exec $DAEMON $DAEMON_ARGS
