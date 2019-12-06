#!/bin/sh
# This runs INSIDE the docker container.
PATH_HAPROXY_CONF="/etc/haproxy/haproxy.cfg"

stats_port=${HAPROXY_STATS_PORT:-80}
haproxy_port=${HAPROXY_PORT:-6379}
timeout_connect=${HAPROXY_TIMEOUT_CONNECT:-2s}
timeout_server=${HAPROXY_TIMEOUT_SERVER:-6s}
timeout_client=${HAPROXY_TIMEOUT_CLIENT:-6s}
redis_backend1=${HAPROXY_BACKEND1:-10.10.0.1:6379}
redis_backend2=${HAPROXY_BACKEND2:-10.10.0.2:6379}
redis_backend3=${HAPROXY_BACKEND3:-10.10.0.3:6379}

# Replace values in template
perl -p -i -e "s/\{\{ stats_port \}\}/$stats_port/" $PATH_HAPROXY_CONF
perl -p -i -e "s/\{\{ haproxy_port \}\}/$haproxy_port/" $PATH_HAPROXY_CONF
perl -p -i -e "s/\{\{ timeout_connect \}\}/$timeout_connect/" $PATH_HAPROXY_CONF
perl -p -i -e "s/\{\{ timeout_server \}\}/$timeout_server/" $PATH_HAPROXY_CONF
perl -p -i -e "s/\{\{ timeout_client \}\}/$timeout_client/" $PATH_HAPROXY_CONF
perl -p -i -e "s/\{\{ redis_backend1 \}\}/$redis_backend1/" $PATH_HAPROXY_CONF
perl -p -i -e "s/\{\{ redis_backend2 \}\}/$redis_backend2/" $PATH_HAPROXY_CONF
perl -p -i -e "s/\{\{ redis_backend3 \}\}/$redis_backend3/" $PATH_HAPROXY_CONF



