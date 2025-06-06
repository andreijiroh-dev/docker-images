# syntax=docker/dockerfile:1.3
ARG ALPINE_RELEASE=edge
FROM alpine:${ALPINE_RELEASE}

LABEL org.opencontainers.image.description="Custom CI image for Alpine Linux package devs and maintainers" \
      org.opencontainers.image.source="https://github.com/andreijiroh-dev/docker-images" \
      org.opencontainers.image.vendor="Andrei Jiroh Halili" \
      org.opencontainers.image.url="https://go.andreijiroh.dev/docker-apkbuild" \
      org.opencontainers.image.documentation="https://github.com/andreijiroh-dev/docker-images/blob/main/docker/pkgops-alpine/README.md" \
      org.opencontainers.image.license="MPL-2.0"
LABEL dev.recaptime.opensource.stabilityLevel="unstable" \
      dev.recaptime.opensource.maintainer="ajhalili2006" \
      dev.recaptime.opensource.license="MPL-2.0" \
      dev.recaptime.opensource.repoOwnerType="staff-verified-public" 

# ref: https://gitlab.alpinelinux.org/alpine/infra/docker/build-base/-/merge_requests/1
ENV SUDO=doas

COPY overlay/ /

# Ensures that file permissions are fixed without hacking around /etc/shadow
ARG BULLDOZER_UID=33333

# ref: https://gitlab.com/MadeByThePinsHub/infra/docker/custom-cicd-images/-/blob/main/docker/bulldozer-abuild/Dockerfile
RUN apk add --no-cache \
  # Alpine devenv starter pack
  alpine-sdk \
  abuild \
  atools \
  lua-aports \
  pigz \
  # sudo is being moved to community repo since the dev team recommends doas instead.
  doas \
  # in case an package needs glibc-based libs
  gcc \
  gcc-gnat \
  # base Git packages
  git \
  git-lfs \
  # GLab CLI for authenication purposes
  glab \
  # performance monitoring inside the container
  htop \
  # Text editor, though you can change it by forking or using the ../data/custom-uid.Dockerfile
  nano \
  # All shell script issues shall be shallow.
  shellcheck \
  spdx-licenses-list \
  # For init system management, instead of going full-blown openrc
  dumb-init \
  # Git-over-SSH access + agents
  openssh-client \
  gpg \
  gpg-agent \
  keychain

# Separate adduser step for cache btw
RUN adduser -u "$BULLDOZER_UID" -D bulldozer && addgroup bulldozer wheel && addgroup bulldozer abuild

USER bulldozer

WORKDIR /home/bulldozer/aports

# Attempt to emulate GitLab CI as possible
ARG CI_MERGE_REQUEST_TARGET_BRANCH_NAME=master
ENV CI_MERGE_REQUEST_PROJECT_URL=https://gitlab.alpinelinux.org/alpine/aports \
    CI_MERGE_REQUEST_TARGET_BRANCH_NAME="$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" \
    # The maximum artifact size in Alpine Linux GitLab instance is 300 MB.
    MAX_ARTIFACT_SIZE=300000000 \
    # Needed by abuild and othe rtools to ensure we can use root when needed.
    SUDO=doas

# Fix some permission issues on that directory.
RUN doas chown -Rv bulldozer:bulldozer /home/bulldozer

ENTRYPOINT [ "dumb-init", "/usr/local/bin/workspace-init" ]
CMD [ "ash", "-l" ]
