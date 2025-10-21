FROM caddy:builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddyserver/transform-encoder \
    --with github.com/Javex/caddy-fail2ban@main

FROM caddy:latest

COPY --from=builder /usr/bin/caddy /usr/bin/caddy