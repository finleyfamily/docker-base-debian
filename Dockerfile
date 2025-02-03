
FROM python:3.13.1@sha256:137ae4b9f85671bd912a82a19b6966e2655f73e13579b5d6ad4edbddaaf62a9c

###############################################################################
# Image Arguments                                                             #
# --------------------------------------------------------------------------- #
# Each arg must be defined in an "ARG" instruction for each stage before it
# can be used in the build stage.
#
ARG LABEL_AUTHOR="Kyle Finley <kyle@finley.sh>"
ARG LABEL_DESCRIPTION="Base image for Debian Linux."
ARG LABEL_DOCUMENTATION="https://github.com/finleyfamily/docker-base-debian"
ARG LABEL_REPOSITORY="https://github.com/finleyfamily/docker-base-debian"
ARG OI_VERSION="v1.0.0"
ARG S6_OVERLAY_VERSION="v3.2.0.2"
ARG TARGETARCH
ARG TZ="US/Eastern"

ARG S6_OVERLAY_REPO="https://github.com/just-containers/s6-overlay"

ENV TERM="xterm-256color"
ENV TZ="${TZ}"

###############################################################################
# Install packages                                                            #
# --------------------------------------------------------------------------- #
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# https://github.com/linuxserver/docker-mods/blob/mod-scripts
ADD --chmod=744 "https://raw.githubusercontent.com/linuxserver/docker-mods/mod-scripts/lsiown.v1" "/usr/bin/lsiown"
ADD --chmod=755 "https://raw.githubusercontent.com/linuxserver/docker-mods/mod-scripts/with-contenv.v1" "/usr/bin/with-contenv"

COPY rootfs/tmp/ /tmp/

RUN set -o errexit; \
  apt-get update -y; \
  apt-get install -y --no-install-recommends \
    bat \
    ca-certificates \
    colordiff \
    curl \
    direnv \
    git \
    iputils-ping \
    less \
    locales \
    make \
    net-tools \
    nmap \
    sudo \
    tzdata \
    unzip \
    xz-utils \
    zip \
    zsh; \
  apt-get clean; \
  rm -rf /var/lib/apt/lists/*; \
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen; \
  locale-gen; \
  git clone --depth 1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh; \
  git clone --single-branch --depth 1 \
    "https://github.com/zsh-users/zsh-autosuggestions" ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
  git clone --single-branch --depth 1 \
    "https://github.com/zsh-users/zsh-syntax-highlighting.git" ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting;\
  git clone --single-branch --depth 1 \
    "https://github.com/mattmc3/zshrc.d" ~/.oh-my-zsh/custom/plugins/zshrc.d; \
  sed -i -e "s#bin/bash#bin/zsh#" /etc/passwd; \
  mkdir -p ~/.local/bin; \
  ln -s /usr/bin/batcat ~/.local/bin/bat; \
  pip install --disable-pip-version-check --no-cache-dir --no-warn-script-location --upgrade wheel setuptools; \
  pip install --requirement /tmp/requirements.txt --disable-pip-version-check --no-cache-dir --no-warn-script-location; \
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin; \
  curl -sSL https://raw.githubusercontent.com/finleyfamily/oi/refs/heads/master/install.py | python3 - --version "${OI_VERSION}"

###############################################################################
# Install nvm                                                                 #
# --------------------------------------------------------------------------- #
RUN set -ex; \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash; \
  source ~/.nvm/nvm.sh; \
  nvm install "lts/jod" --latest-npm; \
  nvm alias default "lts/jod"; \
  nvm cache clear; \
  rm -rf /tmp/*;

###############################################################################
# Install s6-overlay: https://github.com/just-containers/s6-overlay           #
# --------------------------------------------------------------------------- #
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-aarch64.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-arm.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp

# cspell:words Jxpf
RUN set -o errexit; \
  tar -C / -Jxpf "/tmp/s6-overlay-noarch.tar.xz"; \
  if [ "${TARGETARCH}" == "arm64" ]; then export __S6_OVERLAY_ARCH="aarch64"; elif [ "${TARGETARCH}" == "arm/v7" ]; then export __S6_OVERLAY_ARCH="arm"; else export __S6_OVERLAY_ARCH="x86_64"; fi; \
  echo "using arch for s6-overlay: ${__S6_OVERLAY_ARCH}"; \
  tar -C / -Jxpf "/tmp/s6-overlay-${__S6_OVERLAY_ARCH}.tar.xz"; \
  rm -rf /tmp/node-compile-cache;

COPY rootfs/ /
RUN chmod 1777 /tmp

LABEL org.opencontainers.image.authors="${LABEL_AUTHOR}" \
  org.opencontainers.image.description="${LABEL_DESCRIPTION}" \
  org.opencontainers.image.documentation="${LABEL_DOCUMENTATION}" \
  org.opencontainers.image.source="${LABEL_REPOSITORY}" \
  org.opencontainers.image.title="docker-base-debian "

# Child images need to set this entrypoint if running an app
# ENTRYPOINT ["/init"]

CMD ["/bin/zsh"]
