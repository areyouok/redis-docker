Redis sentinel (with HA support) image just for test purpose.

It start 3 sentinel instances (port 16379,16380,16381) and 3 redis servers(port 6379,6380,6381) in same container.

currently only support client connect from localhost.

use this command to start it:
```
docker run --rm -it -p 6379-6381:6379-6381 -p 26379-26381:26379-26381 areyouok/redis-sentinel
```