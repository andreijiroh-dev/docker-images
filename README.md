# `@ajhalili2006/docker-images`

[![Docker Image Builds](https://github.com/andreijiroh-dev/docker-images/actions/workflows/docker-buildops.yml/badge.svg)](https://github.com/andreijiroh-dev/docker-images/actions/workflows/docker-buildops.yml)
[![Dev Environment Builder](https://github.com/andreijiroh-dev/docker-images/actions/workflows/docker-buildops-devenv.yml/badge.svg)](https://github.com/andreijiroh-dev/docker-images/actions/workflows/docker-buildops-devenv.yml)
[![Repo Sync](https://github.com/andreijiroh-dev/docker-images/actions/workflows/reposync.yml/badge.svg)](https://github.com/andreijiroh-dev/docker-images/actions/workflows/reposync.yml)

Collection of Docker image + Compose recipes and related utilities in one monorepo. Licensed under MPL-2.0.

* Issue Trackers
  * JetBrains YouTrack: <https://ajhalili2006.youtrack.cloud/search/Docker%20Images%20Monorepo%20Issues-20?q=project:%20%7BDocker%20Images%20Monorepo%7D&p=0>
  * GitHub: <https://github.com/andreijiroh-dev/docker-images/issues>
  * mau.dev: <https://mau.dev/andreijiroh-dev/docker-images/issues>
* Repository mirrors
  * GitHub: <https://github.com/andreijiroh-dev/docker-images>
  * mau.dev: <https://mau.dev/andreijiroh-dev/docker-images>

## Namespaces[^2]

| Registry | URL | Description/Notes |
| --- | --- | --- |
| GitHub Container Registry (`ghcr.io/andreijiroh-dev/docker-images/*`) | <https://github.com/orgs/andreijiroh-dev/packages?repo_name=docker-images&ecosystem=container> | Primary namespace for builds |
| Quay.io (`quay.io/andreijiroh-dev/*`) | <https://quay.io/organization/andreijiroh-dev> | Alternative Docker registry in case of GitHub Container Registry downtime |
| GitLab Container Registry on mau.dev (`dock.mau.dev/andreijiroh-dev/docker-images/*`) | <https://mau.dev/andreijiroh-dev/docker-images/container_registry> | Alternative Docker registry in case of GitHub Container Registry downtime[^1], also secondary namespace for GitLab CI builds |

[^1]: For some reasons, the image size and digest is not available due to `Invalid tag: missing manifest digest` error on backend. We are still investigating the issue.
[^2]: For custom Gitpod workspace images, some of them may go into the `gitpodified-workspace-images` namespace on Quay.io.

### Images in this repository

> [!NOTE]
> More images to come in this repository in the future, especially as I consolidate Dockerfiles from different repositories into here.

| Image Name | Links | Description | Base Image |
| --- | --- | --- | --- |
| `mkdocs-material` | [README](./docker/mkdocs-material/Dockerfile), [Dockerfile](./docker/mkdocs-material/Dockerfile), [Mkdocs theme docs](https://squidfunk.github.io/mkdocs-material) | Custom image for `mkdocs-material` with Node.js and other tools @ajhalili2006 used on GitLab CI | `python:3.12-alpine` |
| `pkgops-alpine` | [README](./docker/pkgops-alpine/README.md), [Dockerfile](./docker/pkgops-alpine/Dockerfile) | My Alpine Linux Docker image for `aports` development. | 
