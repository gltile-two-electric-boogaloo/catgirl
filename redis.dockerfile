FROM redis:7.0.1-alpine

RUN apk add --update --no-cache tailscale bash
ADD redis.conf /usr/local/etc/redis/redis.conf

ENTRYPOINT [ "bash", "-c", "tailscaled --tun=userspace-networking --socks5-server=localhost:1055 & tailscale up --authkey=$authkey && redis-server /usr/local/etc/redis/redis.conf" ]