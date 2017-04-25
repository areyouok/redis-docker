#!/bin/sh
set -e
 
waitStart(){
  while true
  do
    sleep 0.1
    redis-cli -p $1 ping > /dev/null
    if [ $? -eq 0 ]; then
      echo redis has started on port $1
      break
    fi
  done
}

# can't create sub dir after VOLUME instruction in Dockerfile, so we create them in shell script
if [ ! -d "/data/redis1" ]; then
  mkdir /data/redis1
fi
if [ ! -d "/data/redis2" ]; then
  mkdir /data/redis2
fi
if [ ! -d "/data/redis3" ]; then
  mkdir /data/redis3
fi
chown redis:redis -R /data

gosu redis redis-server --dir /data/redis1 --port 6379 > /var/log/redis_6379 2>&1 &
waitStart 6379
gosu redis redis-server --dir /data/redis2 --port 6380 --slaveof 127.0.0.1 6379 > /var/log/redis_6380 2>&1 &
waitStart 6380
gosu redis redis-server --dir /data/redis3 --port 6381 --slaveof 127.0.0.1 6379 > /var/log/redis_6381 2>&1 &
waitStart 6381


redis-sentinel /etc/sentinel1.conf &
redis-sentinel /etc/sentinel2.conf &
redis-sentinel /etc/sentinel3.conf &

tail -f /var/log/redis_6379 /var/log/redis_6380 /var/log/redis_6381

