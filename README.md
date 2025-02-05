# docker-base-debian

[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/finleyfamily/docker-base-debian/master.svg)](https://results.pre-commit.ci/latest/github/finleyfamily/docker-base-debian/master)
[![renovate](https://img.shields.io/badge/enabled-brightgreen?logo=renovatebot&logoColor=%2373afae&label=renovate)](https://developer.mend.io/github/finlyfamily/docker-base-debian)
[![license][license-shield]](./LICENSE)

A custom base image built with Debian Linux.

**Table Of Contents** <!-- markdownlint-disable-line MD036 -->

<!-- mdformat-toc start --slug=github --no-anchors --maxlevel=6 --minlevel=2 -->

- [Features](#features)

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
- [`bat`]
- [`chezmoi`]
- [`direnv`]
- [`jq`](https://jqlang.org/)
- [`nvm`]
- [Oh My Zsh]
  - [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions)
  - [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting)
  - [`zshrc.d`](https://github.com/mattmc3/zshrc.d)
- [`oi`](https://github.com/finleyfamily/oi)
- [`s6-overlay`]

[license-shield]: https://img.shields.io/github/license/finleyfamily/docker-base-debian.svg
[oh my zsh]: https://github.com/ohmyzsh/ohmyzsh
[`bat`]: https://github.com/sharkdp/bat
[`chezmoi`]: https://github.com/twpayne/chezmoi
[`direnv`]: https://github.com/direnv/direnv
[`nvm`]: https://github.com/nvm-sh/nvm
[`s6-overlay`]: https://github.com/just-containers/s6-overlay
