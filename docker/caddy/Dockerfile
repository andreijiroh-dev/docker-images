# syntax=docker/dockerfile:1
FROM tailscale/tailscale:latest as tailscale

FROM caddy:builder-alpine as builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddy-dns/vercel \
    --with github.com/caddy-dns/netlify \
    --with github.com/ss098/certmagic-s3 \
    --with github.com/sagikazarmark/caddy-fs-s3 \
    --with github.com/kadeessh/kadeessh

FROM caddy:alpine as deploy

COPY entrypoint.sh /usr/local/bin/
RUN apk add --no-cache ca-certificates iptables iproute2 ip6tables \
    && mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=tailscale /usr/local/bin/tailscale /usr/local/bin/tailscaled /usr/local/bin/
RUN ["/usr/local/bin/entrypoint.sh"]
