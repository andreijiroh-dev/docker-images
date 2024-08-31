ARG BUILDPACK_DEPS_TAG=noble
ARG GITLAB_DEPENDENCY_PROXY_PATH=mau.dev/andreijiroh-dev
FROM ${GITLAB_DEPENDENCY_PROXY_PATH}/dependency_proxy/containers/buildpack-deps:${BUILDPACK_DEPS_TAG}

USER root

# Get the utility scripts from gitpod for use during the build.
RUN curl -o /usr/local/bin/install-packages -fsSL https://github.com/gitpod-io/workspace-images/raw/main/base/install-packages \
    && chmod +x /usr/local/bin/install-packages \
    && ln -s /usr/local/bin/install-packages /usr/local/bin/upgrade-packages

RUN yes | unminimize \
    && install-packages \
        zip \
        unzip \
        bash-completion \
        build-essential \
        ninja-build \
        htop \
        iputils-ping \
        jq \
        less \
        locales \
        man-db \
        nano \
        ripgrep \
        software-properties-common \
        sudo \
        stow \
        time \
        emacs-nox \
        vim \
        multitail \
        lsof \
        ssl-cert \
        fish \
        zsh \
        yadm \
    && locale-gen en_US.UTF-8 \
    && upgrade-packages

ENV LANG=en_US.UTF-8

COPY sources.list.d/ /etc/apt/sources.list.d/

# Seperate the install via apt part since we dump the *.sources file first
# and we need the dearmored keys to work.
RUN curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xf911ab184317630c59970973e363c90f8f1b6217" > /tmp/key.gpg \
  && gpg --dearmor - < /tmp/key.gpg > /usr/share/keyrings/git-ppa-archive-keyring.gpg \
  && curl -fsSL https://packagecloud.io/github/git-lfs/gpgkey > /tmp/key.gpg \
  && gpg --dearmor - < /tmp/key.gpg > /usr/share/keyrings/github_git-lfs.gpg \
  && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.gpg > /tmp/key.gpg \
  && gpg --dearmor - < /tmp/key.gpg > /usr/share/keyrings/tailscale-archive-keyring.gpg \
  && curl -fsLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/gpg.key'| gpg --dearmor -o /usr/share/keyrings/caddy-xcaddy-archive-keyring.gpg \
  && rm /tmp/key.gpg

RUN install-packages git git-lfs git-email \
    && git lfs install --system --skip-repo

RUN install-packages tailscale \
    && update-alternatives --set ip6tables /usr/sbin/ip6tables-nft

# Setup both devenv user and Gitpod compat user for use in Gitpod.
RUN userdel ubuntu -f -r && \
    useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    && useradd -l -u 1000 -G sudo,gitpod -md /home/user -s /bin/bash -p devenv user \
    # Remove `use_pty` option and enable passwordless sudo.
    && sed -i.bkp -e '/Defaults\tuse_pty/d' -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers \
    && mkdir /workspace && chown -hR gitpod:gitpod /workspace

USER user
WORKDIR /home/user
ARG dotfiles=https://mau.dev/andreijiroh-dev/dotfiles
ARG dotfilesBranch=main
RUN yadm clone ${dotfiles} && yadm restore --staged $HOME && yadm checkout ${dotfilesBranch} -- $HOME