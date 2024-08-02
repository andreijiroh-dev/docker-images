#!/usr/bin sh

if [[ $TAILSCALE_AUTHKEY ]]; then
  tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
  tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=${TAILSCALE_HOSTNAME:-"caddy"}
fi

caddy run --config ${CADDYFILE_PATH:-"/etc/caddy/Caddyfile"} --adapter caddyfile