# syntax=docker/dockerfile:1-labs
ARG GITLAB_DEPENDENCY_PROXY_PATH=mau.dev/andreijiroh-dev

FROM ${GITLAB_DEPENDENCY_PROXY_PATH}/dependency_proxy/containers/tailscale/tailscale:latest as tailscale
FROM ${GITLAB_DEPENDENCY_PROXY_PATH}/dependency_proxy/containers/golang:1.22.5-alpine as golang

# At this stage, we need to compile go from source using go1.22.5 binaries from official image
# while reverting commit 3560cf0afb3c29300a6c88ccd98256949ca7a6f6 as a workaround to
# https://github.com/golang/go/issues/68285.
FROM ${GITLAB_DEPENDENCY_PROXY_PATH}/dependency_proxy/containers/dunglas/frankenphp:alpine as builder
ENV PATH="/usr/local/golang/bin:$PATH" GOROOT=/usr/local/golang GOPATH=/usr/local/golang
RUN apk add --no-cache \
        autoconf \
        dpkg-dev \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkgconfig \
        re2c \
        argon2-dev \
        brotli-dev \
        coreutils \
        curl-dev \
        gnu-libiconv-dev \
        libsodium-dev \
        libxml2-dev \
        linux-headers \
        oniguruma-dev \
        openssl-dev \
        readline-dev \
        sqlite-dev \
        upx \
        # Needed for the custom Go build
        git \
        bash \
    && git config --global user.email "builds@andreijiroh.xyz" \
    && git config --global user.name "BuildOps" \
    && git clone --single-branch --branch go1.22.6 https://github.com/golang/go.git /usr/local/golang

WORKDIR /usr/local/golang/src
COPY --from=golang /usr/local/go /usr/local/gobootstrap
RUN export GOROOT_BOOTSTRAP=/usr/local/gobootstrap \
    && git checkout  && git revert 3560cf0afb3c29300a6c88ccd98256949ca7a6f6 \
    && mkdir /go \
    && ./make.bash \
    && /usr/local/golang/bin/go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
ARG CGO_ENABLED=1
ARG XCADDY_GO_BUILD_FLAGS="-ldflags '-w -s'"

RUN xcaddy build \
    --with github.com/sagikazarmark/caddy-fs-s3 \
    --with github.com/dunglas/frankenphp/caddy \
    --with github.com/dunglas/caddy-cbrotli \
    --with github.com/dunglas/mercure/caddy \
    --with github.com/dunglas/vulcain/caddy \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddy-dns/vercel \
    --with github.com/caddy-dns/netlify \
    --with github.com/ss098/certmagic-s3 \
    --with github.com/sagikazarmark/caddy-fs-s3 \
    --output /usr/local/bin/frankenphp-buildkit \
    && setcap cap_net_bind_service=+ep /usr/local/bin/frankenphp-buildkit \
	&& upx --best /usr/local/bin/frankenphp-buildkit

FROM ${GITLAB_DEPENDENCY_PROXY_PATH}/dependency_proxy/containers/dunglas/frankenphp:alpine as runner

LABEL org.opencontainers.image.description="Custom FrankenPHP Docker image with additional Caddy DNS and storage plugins" \
      org.opencontainers.image.source="https://github.com/andreijiroh-dev/docker-images" \
      org.opencontainers.image.vendor="Andrei Jiroh Halili" \
      org.opencontainers.image.url="https://go.andreijiroh.dev/caddy" \
      org.opencontainers.image.documentation="https://github.com/andreijiroh-dev/docker-images/blob/main/docker/caddy/README.md" \
      org.opencontainers.image.license="MPL-2.0"
LABEL dev.recaptime.opensource.stabilityLevel="unstable" \
      dev.recaptime.opensource.maintainer="ajhalili2006" \
      dev.recaptime.opensource.license="MPL-2.0" \
      dev.recaptime.opensource.repoOwnerType="staff-verified-public" 

COPY --from=builder /usr/local/bin/frankenphp-buildkit /usr/local/bin/frankenphp
COPY --from=tailscale /usr/local/bin/tailscale /usr/local/bin/tailscaled /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/
RUN apk add --no-cache ca-certificates iptables iproute2 ip6tables dumb-init bash \
    && mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale \
    && chmod +x /usr/local/bin/entrypoint.sh \
    && ln -s /usr/local/bin/frankenphp /usr/local/bin/caddy \
    && setcap cap_net_bind_service=+ep /usr/local/bin/frankenphp
ENTRYPOINT [ "dumb-init" ]
CMD ["/usr/local/bin/entrypoint.sh"]
