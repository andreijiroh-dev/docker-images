ARG BUILDPACK_DEPS_TAG=jammy
FROM buildpack-deps:${BUILDPACK_DEPS_TAG}

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
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
  && rm /tmp/key.gpg

# https://docs.docker.com/engine/install/ubuntu/
RUN  \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt update \
    && install-packages docker-ce=5:24.0.9-1~ubuntu.22.04~jammy docker-ce-cli=5:24.0.9-1~ubuntu.22.04~jammy containerd.io docker-buildx-plugin

RUN curl -o /usr/local/bin/docker-compose -fsSL https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-linux-$(uname -m) \
    && chmod +x /usr/local/bin/docker-compose && mkdir -p /usr/local/lib/docker/cli-plugins && \
    ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

# https://github.com/wagoodman/dive
RUN curl -o /tmp/dive.deb -fsSL https://github.com/wagoodman/dive/releases/download/v0.11.0/dive_0.11.0_linux_amd64.deb \
    && apt install /tmp/dive.deb \
    && rm /tmp/dive.deb

RUN install-packages git git-lfs git-email \
    && git lfs install --system --skip-repo

RUN install-packages tailscale \
    && update-alternatives --set ip6tables /usr/sbin/ip6tables-nft

# Setup Gitpod user for compat
RUN userdel ubuntu -f -r && \
    useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # Remove `use_pty` option and enable passwordless sudo.
    && sed -i.bkp -e '/Defaults\tuse_pty/d' -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers \
    && mkdir /workspace && chown -hR gitpod:gitpod /workspace

USER gitpod
WORKDIR /home/gitpod

RUN sudo echo hello world >> /dev/null \
    && mkdir -p /home/gitpod/.bashrc.d && \
    (echo; echo "for i in \$(ls -A \$HOME/.bashrc.d/); do source \$HOME/.bashrc.d/\$i; done"; echo) >> /home/gitpod/.bashrc \
    && mkdir -p /home/gitpod/.local/share/bash-completion/completions

ARG NODE_VERSION=v20.17.0 # TODO: Automate this on GitHub Actions
ENV NODE_VERSION=${NODE_VERSION} PNPM_HOME=/home/gitpod/.pnpm
ENV PATH=$HOME/.local/bin:/usr/games:/home/gitpod/.nvm/versions/node/v${NODE_VERSION}/bin:/home/gitpod/.yarn/bin:${PNPM_HOME}:$PATH

## Node.js
RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | PROFILE=/dev/null bash \
    && bash -c ". .nvm/nvm.sh \
        && nvm install v${NODE_VERSION} \
        && nvm alias default v${NODE_VERSION} \
        && npm install -g typescript yarn pnpm node-gyp" \
    && echo ". ~/.nvm/nvm-lazy.sh"  >> /home/gitpod/.bashrc.d/50-node \
    && wget https://github.com/gitpod-io/workspace-images/raw/main/chunks/lang-node/nvm-lazy.sh -O ~/.nvm/nvm-lazy.sh
