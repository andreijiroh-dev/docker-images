# Custom `mkdocs-material` CI image

Builds on Alpine edge, mostly used by @ajhalili2006 to deploy builds over GitLab CI.

## Usage

See the tags list on [GitHub][ghcr], [GitLab][maudev] or [Red Hat Quay Container Registry Cloud][quay]

[ghcr]: https://github.com/andreijiroh-dev/docker-images/pkgs/container/docker-images%2Fmkdocs-material/versions
[quay]: https://quay.io/repository/ajhalili2006/mkdocs-material-build-ci?tab=tags
[maudev]: https://mau.dev/andreijiroh-dev/docker-images

```yaml
# in GitLab CI config...
image:
  name: dock.mau.dev/andreijiroh-dev/docker-images/mkdocs-material
```

```dockerfile
# ...or via your custom Docker image
FROM ghcr.io/ajhalili2006/website/build-ci:latest
```
