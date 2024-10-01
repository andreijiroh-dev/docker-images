# `caddy` with plugins + `tailscale`

We use a custom build of Caddy with hand-picked plugins and Tailscale

## Included caddy plugins

### DNS challenges

* <https://github.com/caddy-dns/cloudflare>
* <https://github.com/caddy-dns/vercel>
* <https://github.com/caddy-dns/netlify>

### S3-compatble API storage

* <https://github.com/ss098/certmagic-s3>
* <https://github.com/sagikazarmark/caddy-fs-s3>

### PHP setups



## Extracting the binary

```bash
docker run --rm -v ./out:/out ghcr.io/andreijiroh-dev/docker-images/caddy # (or frankenphp)
```
