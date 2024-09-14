#!/usr/bin/env bash

if ! command -v chezmoi &>/dev/null; then

  if command -v brew &>/dev/null; then
    brew install chezmoi

  elif [[ $(uname -o) == "Android" ]]; then
    apt update
    apt install -y chezmoi

  else

    . /etc/os-release

    if [ "$ID_LIKE" = "arch" ]; then
      sudo pacman -Sy --noconfirm chezmoi

    elif [ "$ID_LIKE" = "opensuse suse" ]; then
      sudo zypper refresh
      sudo zypper --non-interactive --no-confirm install chezmoi

    elif command -v curl &>/dev/null; then
      mkdir -p $HOME/.local/bin
      sh -c "$(curl -fsLS get.chezmoi.io) -- -b $HOME/.local/bin"

    elif command -v wget &>/dev/null; then
      mkdir -p $HOME/.local/bin
      sh -c "$(wget -qO- get.chezmoi.io) -- -b $HOME/.local/bin"
    fi

    if [ -f $HOME/.local/bin/chezmoi ]; then
      if ! grep -q '.local/bin' $HOME/.bashrc; then
        echo 'export PATH=$HOME/.local/bin:$PATH' >>$HOME/.bashrc
      fi
      if ! grep -q '.local/bin' $HOME/.zshrc; then
        echo 'export PATH=$HOME/.local/bin:$PATH' >>$HOME/.zshrc
      fi
      if ! grep -q '.local/bin' $HOME/.config/fish/config.fish; then
        mkdir -p $HOME/.config/fish
        echo "set -a fish_user_paths $HOME/.local/bin" >>$HOME/.config/fish/config.fish
      fi
    fi

  fi
fi
