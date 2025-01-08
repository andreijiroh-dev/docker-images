# Alpine Linux aports CI image

A Docker-based development environment for package maintainers in Alpine Linux distribution, based off the `edge` branch for the builds.

## Docker image URLs

* GHCR: `ghcr.io/andreijiroh-dev/docker-images/pkgops-alpine`
* GLCR: `dock.mau.dev/andreijiroh-dev/docker-images/pkgops-alpine`
* RHQCR: `quay.io/andreijiroh-dev/pkgops-alpine`
* Docker Hub: `ajhalili2006/pkgops-alpine`

## Usage

> [!WARNING]
> This image ships with a [test signing key][key] that should not be used in production other than for CI use only. For context behind this, see also [Termux app README](https://github.com/termux/termux-app?tab=readme-ov-file#github).

[key]: ./overlay/home/bulldozer/.abuild/bot+pkgops-alpinelinux@andreijiroh.xyz-61c57aff.rsa

You need to have a local copy of the [`aports`](https://gitlab.alpinelinux.org/alpine/aports)
repository, as well as having root access for `USER_UID` and `USER_GID` usage.

```bash
# launch a interactive shell
docker run --rm -it \
  # change /path/to/aports to directory of your local aports copy
  -v /path/to/aports:/home/bulldozer/aports \
  # mount ~/.abuild into container's to use your own keys
  -v "$HOME/.abuild:/home/bulldozer/.abuild" \
  dock.mau.dev/andreijiroh-dev/docker-images/pkgops-alpine

# bump version and build for GitHub CLI
docker run --rm -it \
  # change /path/to/aports to directory of your local aports copy
  -v /path/to/aports:/home/bulldozer/aports \
  # mount ~/.abuild into container's to use your own keys
  -v "$HOME/.abuild:/home/bulldozer/.abuild" \
  dock.mau.dev/andreijiroh-dev/docker-images/pkgops-alpine abuild github-cli-2.52.1
```

### Available flags

| Variable | Description | Example |
| --- | --- | --- |
| `GITLAB_TOKEN` | GitLab API token for CLI usage | N/A |
| `GITLAB_HOST` | GitLab instance host for CLI usage | `https://gitlab.alpinelinux.org` |
| `USER_UID` | Primarily used for permission fixes during startup | `1000` |
| `USER_GID` | Primarily used for permission fixes during startup | `1000` |

## Using as base image

```dockerfile
FROM dock.mau.dev/andreijiroh-dev/docker-images/pkgops-alpine
```
