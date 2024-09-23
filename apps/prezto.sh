#!/bin/bash

if ! command -v zsh &>/dev/null; then
  if [[ $(uname -o) == "Darwin" ]]; then
    echo zsh is macOS default and already installed, but git is still needed
    brew install git

  elif [[ $(uname -o) == "Android" ]]; then
    apt update
    apt install -y zsh git

  else
    . /etc/os-release

    if command -v pacman &>/dev/null; then
      sudo pacman -Sy zsh git

    elif command -v rpm-ostree &>/dev/null; then
      sudo rpm-ostree install --apply-live -y zsh git

    elif command -v zypper &>/dev/null; then
      sudo zypper refresh
      sudo zypper --non-interactive --no-confirm install zsh git

    elif command -v dnf &>/dev/null; then
      dnf check-update
      sudo dnf install -y zsh git

    elif command -v apt &>/dev/null; then
      sudo apt update
      sudo apt install -y zsh git

    fi

    sudo sed -i "s|^\($USER.*\)/bin/bash|\1/bin/zsh|" /etc/passwd
    sudo sed -i "s|^\($USER.*\)/bin/fish|\1/bin/zsh|" /etc/passwd
  fi
fi

zsh <<'EOF'
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
EOF
