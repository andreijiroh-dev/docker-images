#!/usr/bin/env bash
set -xe
TAILSCALE_AUTHKEY=${TAILSCALE_AUTHKEY:-""}
TAILSCALE_HOSTNAME=${TAILSCALE_HOSTNAME:-"caddy"}
TAILSCALE_UP_ADDITIONAL_ARGS=${TAILSCALE_UP_ADDITIONAL_ARGS:-""}
TAILSCALE_TAGS="tag:caddy,tag:docker"
CADDYFILE_PATH=${CADDYFILE_PATH:-"/etc/caddy/Caddyfile"}

tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
if [[ $TAILSCALE_AUTHKEY != "" ]]; then
    tailscale up \
        --authkey="${TAILSCALE_AUTHKEY}" \
        --hostname=${TAILSCALE_HOSTNAME} \
        --accept-tags=${TAILSCALE_TAGS} \
        ${TAILSCALE_UP_ADDITIONAL_ARGS}
fi

caddy run --config ${CADDYFILE_PATH}