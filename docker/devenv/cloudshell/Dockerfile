FROM gcr.io/cloudshell-images/cloudshell:latest

# Load up our repo lists and GPG keys
COPY sources.list.d/ /etc/apt/sources.list.d
RUN curl -fsSL https://packagecloud.io/github/git-lfs/gpgkey > /tmp/key.gpg \
    && gpg --dearmor - < /tmp/key.gpg > /usr/share/keyrings/github_git-lfs.gpg \
    && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.gpg > /tmp/key.gpg \
    && gpg --dearmor - < /tmp/key.gpg > /usr/share/keyrings/tailscale-archive-keyring.gpg \
    && rm /tmp/key.gpg \
    && curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb \
    && curl -sSLo /tmp/mysql-apt-config.deb https://dev.mysql.com/get/mysql-apt-config_0.8.32-1_all.deb \
    && dpkg -i /tmp/debsuryorg-archive-keyring.deb && dpkg -i /tmp/mysql-apt-config.deb && rm /tmp/*.deb

# Do install and cleanup in one-step
RUN apt-get update --allow-releaseinfo-change && \
    apt-get upgrade -y \
    && apt-get install -y git-lfs tailscale \
    && apt-get clean \
    && curl -fsSL https://getcroc.schollz.com | bash \
    && rm -rf /var/cache/debconf/* /var/lib/apt/lists/* /tmp/* /var/tmp/*