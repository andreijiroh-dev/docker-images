# Custom `mkdocs-material` CI image

An custom `mkdocs-material` Docker image with Node.js preinstalled on latest
stable version of Alpine Linux. Used for building my mkdocs-based main website
and personal wiki.

* **Theme docs**: <https://squidfunk.github.io/mkdocs-material>

## Usage

See the tags list on [GitHub][ghcr], [GitLab][maudev] or [Red Hat Quay Container Registry Cloud][quay].

[ghcr]: https://github.com/andreijiroh-dev/docker-images/pkgs/container/docker-images%2Fmkdocs-material/versions
[quay]: https://quay.io/repository/ajhalili2006/mkdocs-material-build-ci?tab=tags
[maudev]: https://mau.dev/andreijiroh-dev/docker-images/container_registry/102

```yaml
# in GitLab CI config...
image:
  name: dock.mau.dev/andreijiroh-dev/docker-images/mkdocs-material
  entrypoint: [ "/bin/bash", "-lc" ]

pages:
  environment:
    name: production
    url: https://your-project.pages.dev
  before_script:
  - pip3 install -r requirements.txt
  script:
  - mkdocs build -d public
  - doppler run -- npx wrangler pages deploy --branch "${CI_DEFAULT_BRANCH}" --project-name ${CF_PAGES_PROJECT} public
  artifacts:
    paths:
      - public
  rules:
    - if: $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH
```

```dockerfile
# ...or via your custom Docker image
FROM ghcr.io/andreijiroh-dev/docker-images/mkdocs-material:latest

# Install docs: https://squidfunk.github.io/mkdocs-material/insiders/getting-started/#installation
# Passing secrets during docker build: https://docs.docker.com/build/building/secrets/#secret-mounts
RUN --mount=type=secret,id=GH_TOKEN \
    pip uninstall mkdocs-material \
    && GH_TOKEN=$(cat /run/secrets/GH_TOKEN) \
       pip install git+https://${GH_TOKEN}@github.com/squidfunk/mkdocs-material-insiders.git
```

If you do want to use the sponsorware Insiders edition, you need to install from source
within your CI or pre-install it using the Dockerfile method.

## Software included in this image

Other than Python 3.12 and everything pre-installed in Alpine Linux by default:

* Required for use in GitLab CI and beyond: `bash`, `coreutils`, `git`, `gnupg`, `curl`, `wget`, `rsync`, `openssh`
* Linting tools: `hadolint` (copied from its official image), `shellcheck`
* `doppler` for secrets management and access in GitLab CI
* Git tools: `git-email`, `git-lfs`, `git-fast-import`
* Dev packages for social card image generation: `cairo-dev`, `freetype-dev`, `libffi-dev`, `jpeg-dev`, `libpng-dev`,`zlib-dev`
* Additional Python packages: `mkdocs-git-committers-plugin-2`, `mkdocs-git-revision-date-localized-plugin`, `mkdocs-minify-plugin`, `mkdocs-redirects`, `mkdocs-rss-plugin`,`pillow`, `cairosvg`, `pipenv`, `pipx`
* Other dev tools: `libstdc++`, `musl-dev`, `gcc`
