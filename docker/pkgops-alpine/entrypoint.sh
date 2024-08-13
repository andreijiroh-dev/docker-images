#!/usr/bin sh

if [[ $TAILSCALE_AUTHKEY ]]; then
  tailscaled --tun=userspace-networking \
    --socks5-server=localhost:1055 \
    --state=${TAILSCALE_STATEDIR:-"mem:"} &
  tailscale up --authkey=${TAILSCALE_AUTHKEY} \
    --hostname=${TAILSCALE_HOSTNAME:-"caddy"} \
    --advertise-tags
fi

caddy run --environ --config ${CADDYFILE_PATH:-"/etc/caddy/Caddyfile"} --adapter caddyfile