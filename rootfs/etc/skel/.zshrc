#! /usr/bin/env bash

if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
  export PATH="/usr/local/bin:/usr/local/sbin:$HOME/bin:$HOME/.local/bin:$PATH";
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh";
export ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom";

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# shellcheck disable=SC2034
ZSH_THEME="agnoster";

# Uncomment one of the following lines to change the auto-update behavior
autoload -U +X bashcompinit && bashcompinit;
zstyle ':omz:update' mode disabled;  # disable automatic updates

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# shellcheck disable=SC2034
plugins=(
  zshrc.d  # https://github.com/mattmc3/zshrc.d
  git
  zsh-autosuggestions  # https://github.com/zsh-users/zsh-autosuggestions
  zsh-syntax-highlighting  # https://github.com/zsh-users/zsh-syntax-highlighting
)

# shellcheck disable=SC1091
source "${ZSH}/oh-my-zsh.sh";

# User configuration
