#! /usr/bin/env bash
#
# Loaded at user login.

if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
  export PATH="/usr/local/bin:/usr/local/sbin:$HOME/bin:$HOME/.local/bin:$PATH";
fi

# nvm setup
export NVM_DIR="$HOME/.nvm";
if [[ -d "${NVM_DIR}" ]]; then
  # shellcheck disable=SC1091
  [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh";  # This loads nvm
  # shellcheck disable=SC1091
  [ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion";  # This loads nvm bash_completion
fi
