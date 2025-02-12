# docker-base-debian

[![GitHub Release](https://img.shields.io/github/v/release/finleyfamily/docker-base-debian?logo=github&color=2496ED)](https://github.com/finleyfamily/docker-base-debian/releases)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/finleyfamily/docker-base-debian/master.svg)](https://results.pre-commit.ci/latest/github/finleyfamily/docker-base-debian/master)
[![renovate](https://img.shields.io/badge/renovate-enabled-brightgreen?logo=renovate&logoColor=143C8C)](https://developer.mend.io/github/finleyfamily/docker-base-debian)
[![license][license-shield]](./LICENSE)

A custom base image built with Debian Linux.

**Table Of Contents** <!-- markdownlint-disable-line MD036 -->

<!-- mdformat-toc start --slug=github --no-anchors --maxlevel=6 --minlevel=2 -->

- [Features](#features)
- [Configuration](#configuration)
  - [Environment Variables](#environment-variables)
  - [Volumes](#volumes)
    - [`/config`](#config)
    - [`/root/.local/share/chezmoi`](#rootlocalsharechezmoi)

<!-- mdformat-toc end -->

______________________________________________________________________

## Features

- Python 3.13
  - `pipx`
  - `poetry`
    - `poetry-dynamic-versioning`
    - `poetry-plugin-export`
    - `poetry-plugin-shell`
  - `yq`
- multiple architectures
- non-root user (defaults to `admin`)
  - name, home directory, UID, and GID can be changed when the container is started
- [`bat`]
- [`chezmoi`] for dotfiles
- [`direnv`]
- [`jq`](https://jqlang.org/)
- [`nvm`]
- [Oh My Zsh]
  - [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions)
  - [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting)
  - [`zshrc.d`](https://github.com/mattmc3/zshrc.d)
- [`oi`](https://github.com/finleyfamily/oi)
- [`s6-overlay`]

______________________________________________________________________

## Configuration

Configuration is done through a combination of environment variables and volumes/bind mounts.

### Environment Variables

| Variable       | Default | Description                                                                                         |
| -------------- | ------- | --------------------------------------------------------------------------------------------------- |
| `_GID`         | `568`   | GID of the non-root user group created and used by the container.                                   |
| `_UID`         | `568`   | UID for the non-root user created and used by the container.                                        |
| `_USER`        | `admin` | Name of the non-root user created and used by the container.                                        |
| `CHEZMOI_REPO` |         | Git repository that [`chezmoi`] will use to setup dotfiles. If not provided, dotfile are not setup. |

### Volumes

#### `/config`

The `/config` volume is used to store the majority of configuration files and persistant data.

#### `/root/.local/share/chezmoi`

While optional, a volume can be used to cache the [`chezmoi`] git repository.

```yaml
services:
  service-name:
    volumes:
      - source: chezmoi-repo
        target: /root/.local/share/chezmoi
        type: volume

volumes:
  chezmoi-repo:
    driver: local
    labels:
      org.opencontainers.volume.description: Volume used to cache chezmoi dotfile repository.
```

[license-shield]: https://img.shields.io/github/license/finleyfamily/docker-base-debian.svg
[oh my zsh]: https://github.com/ohmyzsh/ohmyzsh
[`bat`]: https://github.com/sharkdp/bat
[`chezmoi`]: https://github.com/twpayne/chezmoi
[`direnv`]: https://github.com/direnv/direnv
[`nvm`]: https://github.com/nvm-sh/nvm
[`s6-overlay`]: https://github.com/just-containers/s6-overlay
