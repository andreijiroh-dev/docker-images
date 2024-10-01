# syntax=docker/dockerfile:1
FROM tailscale/tailscale:latest as tailscale

FROM caddy:builder-alpine as builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddy-dns/vercel \
    --with github.com/caddy-dns/netlify \
    --with github.com/ss098/certmagic-s3 \
    --with github.com/sagikazarmark/caddy-fs-s3

FROM caddy:alpine as runner

LABEL org.opencontainers.image.description="Plain Caddy and community plugins, minus FrankenPHP." \
      org.opencontainers.image.source="https://github.com/andreijiroh-dev/docker-images" \
      org.opencontainers.image.vendor="Andrei Jiroh Halili" \
      org.opencontainers.image.url="https://go.andreijiroh.xyz/mkdocs-material" \
      org.opencontainers.image.documentation="https://github.com/andreijiroh-dev/docker-images/blob/main/docker/mkdocs-material/README.md" \
      org.opencontainers.image.license="MPL-2.0"
LABEL dev.recaptime.opensource.stabilityLevel="unstable" \
      dev.recaptime.opensource.maintainer="ajhalili2006" \
      dev.recaptime.opensource.license="MPL-2.0" \
      dev.recaptime.opensource.repoOwnerType="staff-verified-public" 

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=tailscale /usr/local/bin/tailscale /usr/local/bin/tailscaled /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/

RUN apk add --no-cache ca-certificates iptables iproute2 ip6tables bash ca-certificates libcap mailcap \
    && mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale \
    && setcap cap_net_bind_service=+ep /usr/bin/caddy

ENTRYPOINT [ "/usr/bin/dumb-init" ]
CMD ["/usr/local/bin/entrypoint.sh"]
