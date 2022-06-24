FROM redis:7.0.1-alpine

RUN apk --update --no-cache add curl

ADD redis.conf /usr/local/etc/redis/redis.conf

ENTRYPOINT [ "redis-server", "/usr/local/etc/redis/redis.conf" ]