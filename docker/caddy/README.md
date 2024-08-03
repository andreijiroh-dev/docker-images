# `caddy` with plugins + `tailscale`

## Included caddy plugins

### DNS challenges

* <https://github.com/caddy-dns/cloudflare>
* <https://github.com/caddy-dns/vercel>
* <https://github.com/caddy-dns/netlify>

### S3-compatble API storage

* <https://github.com/ss098/certmagic-s3>
* <https://github.com/sagikazarmark/caddy-fs-s3>

## Extracting the binary

```
docker run -v /path/to/caddyfile:/etc/caddy/Caddyfile -p 8080:8080 quay.io/andreijiroh-dev/caddy-tailscale

```