#!/bin/sh
echo "512" >  /proc/sys/net/core/somaxconn
sysctl vm.overcommit_memory=1
echo never > /sys/kernel/mm/transparent_hugepage/enabled
tee /etc/redis/sentinel.conf <<EOF
port 26379
daemonize yes
logfile "/var/log/sentinel.log"
pidfile "var/run/sentinel.pid"
dir "/var/lib/redis/sentinel"

sentinel monitor docker-cluster $MASTER_HOST $MASTER_PORT $SENTINEL_QUORUM
sentinel down-after-milliseconds docker-cluster $SENTINEL_DOWN_AFTER
sentinel parallel-syncs docker-cluster 1
sentinel failover-timeout docker-cluster $SENTINEL_FAILOVER
EOF

redis-sentinel /etc/redis/sentinel.conf

if [ "$REDIS_IS_SLAVE" == true ]; then
    redis-server --slaveof ${MASTER_HOST} ${MASTER_PORT} --tcp-backlog 511 --timeout 0 --tcp-keepalive 300 --daemonize no --supervised no --pidfile /var/run/redis.pid --loglevel notice --logfile "" --databases 16 --always-show-logo yes --save 900 1 --save 300 10 --save 60 10000 --stop-writes-on-bgsave-error no --rdbcompression yes --rdbchecksum yes --dbfilename dump.rdb --dir /data --replica-serve-stale-data yes --replica-read-only yes --repl-diskless-sync no --repl-diskless-sync-delay 5 --repl-disable-tcp-nodelay no --replica-priority 100 --maxmemory 2gb --maxmemory-policy allkeys-lru --lazyfree-lazy-eviction no --lazyfree-lazy-expire no --lazyfree-lazy-server-del no --replica-lazy-flush no --appendonly yes --appendfilename "appendonly.aof" --appendfsync everysec --no-appendfsync-on-rewrite no --auto-aof-rewrite-percentage 100 --auto-aof-rewrite-min-size 64mb --aof-load-truncated yes --aof-use-rdb-preamble yes --lua-time-limit 5000 --slowlog-log-slower-than 10000 --slowlog-max-len 128 --latency-monitor-threshold 0 --notify-keyspace-events "" --hash-max-ziplist-entries 512 --hash-max-ziplist-value 64 --list-max-ziplist-size -2 --list-compress-depth 0 --set-max-intset-entries 512 --zset-max-ziplist-entries 128 --zset-max-ziplist-value 64 --hll-sparse-max-bytes 3000 --stream-node-max-bytes 4096 --stream-node-max-entries 100 --activerehashing yes --client-output-buffer-limit normal 0 0 0 --client-output-buffer-limit replica 256mb 64mb 60 --client-output-buffer-limit pubsub 32mb 8mb 60 --hz 10 --dynamic-hz yes --aof-rewrite-incremental-fsync yes --rdb-save-incremental-fsync yes  --slave-priority ${SLAVE_PRIORITY}
else
    redis-server --port ${MASTER_PORT} --tcp-backlog 511 --timeout 0 --tcp-keepalive 300 --daemonize no --supervised no --pidfile /var/run/redis.pid --loglevel notice --logfile "" --databases 16 --always-show-logo yes --save 900 1 --save 300 10 --save 60 10000 --stop-writes-on-bgsave-error no --rdbcompression yes --rdbchecksum yes --dbfilename dump.rdb --dir /data --replica-serve-stale-data yes --replica-read-only yes --repl-diskless-sync no --repl-diskless-sync-delay 5 --repl-disable-tcp-nodelay no --replica-priority 100 --maxmemory ${REDIS_MAXMEMORY} --maxmemory-policy allkeys-lru --lazyfree-lazy-eviction no --lazyfree-lazy-expire no --lazyfree-lazy-server-del no --replica-lazy-flush no --appendonly yes --appendfilename "appendonly.aof" --appendfsync everysec --no-appendfsync-on-rewrite no --auto-aof-rewrite-percentage 100 --auto-aof-rewrite-min-size 64mb --aof-load-truncated yes --aof-use-rdb-preamble yes --lua-time-limit 5000 --slowlog-log-slower-than 10000 --slowlog-max-len 128 --latency-monitor-threshold 0 --notify-keyspace-events "" --hash-max-ziplist-entries 512 --hash-max-ziplist-value 64 --list-max-ziplist-size -2 --list-compress-depth 0 --set-max-intset-entries 512 --zset-max-ziplist-entries 128 --zset-max-ziplist-value 64 --hll-sparse-max-bytes 3000 --stream-node-max-bytes 4096 --stream-node-max-entries 100 --activerehashing yes --client-output-buffer-limit normal 0 0 0 --client-output-buffer-limit replica 256mb 64mb 60 --client-output-buffer-limit pubsub 32mb 8mb 60 --hz 10 --dynamic-hz yes --aof-rewrite-incremental-fsync yes --rdb-save-incremental-fsync yes
fi
