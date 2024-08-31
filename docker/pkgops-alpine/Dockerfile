# syntax=docker/dockerfile:1.3
ARG ALPINE_RELEASE=edge
ARG GITLAB_DEPENDENCY_PROXY_PATH=mau.dev/andreijiroh-dev
FROM ${GITLAB_DEPENDENCY_PROXY_PATH}/containers/dependency_proxy/alpine:${ALPINE_RELEASE}

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
