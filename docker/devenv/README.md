# ~ajhalili2006's custom devenv images

## Build

You need at least 2 GB of storage and a stable and fast internet connection
to build

> [!note]
> It's best to run the scripts at the root of the repo (or use `direnv` for this purpose) instead of prefixing it with `$(git rev-parse --show-toplevel)/`.
> You may also run into issues if the output of `git rev-parse --show-toplevel` has spaces in it.

### Base image

For base image:

```bash
$(git rev-parse --show-toplevel)/scripts/build devenv/base [custom-image-name]
```

By default, the built image will be tagged with `dock.mau.dev/andreijiroh-dev/docker-images/devenv/base:localdev` which
you'll need on building subsequent images.

**Supported build args**:

* `BUILDPACK_DEPS_TAG`: Use this to lock into specific Ubuntu LTS release at specific SHA-256 digest of the image.
* `dotfiles` - Git-over-HTTPS clone URL of your dotfiles repository that compatible with `yadm`.
* `dotfilesBranch` - Branch name from your dotfiles repo if you seperate configuration files between environments via branches.

### Google Cloud Shell

> [!warning]
> The `gcr.io/cloudshell-images/cloudshell` base image weights at 22.44 GB, so you may need to spare some additional GBs of storage
> since we're doing `apt-get upgrade` behind the scenes.

```bash
scripts/build devenv/cloudshell

# on Google Cloud Shell
cd docker/devenv/cloudshell && cloudshell env build-local
```

### Gitpod workspace image

To build Gitpod-optmized image:

```bash
# To use your local build, pass --build-arg flag as value of DOCKER_BUILD_ARGS
# when running scripts/build.
DOCKER_BUILD_ARGS="--build-arg base=dock.mau.dev/andreijiroh-dev/docker-images/devenv/base:localdev" $(git rev-parse --show-toplevel)/scripts/build devenv/gitpod
```

Once built, you may want to use it to run a debug workspace in Gitpod.

```bash
# You may need to authenicate with your preferred Docker registry for the script
# to work properly.
script/publish-to-staging dock.mau.dev/andreijiroh-dev/docker-images/devenv/gitpod:localdev <target-repo-tag>
```
