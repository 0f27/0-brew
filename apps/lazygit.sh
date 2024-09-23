#!/usr/bin/env bash

if ! command -v lazygit &>/dev/null; then
  if command -v brew &>/dev/null; then
    brew install lazygit

  elif [[ $(uname -o) == "Android" ]]; then
    apt update
    apt install -y lazygit

  else
    . /etc/os-release

    if command -v pacman &>/dev/null; then
      sudo pacman -Sy lazygit

    elif command -v dnf &>/dev/null; then
      sudo dnf copr enable atim/lazygit -y
      sudo dnf install -y lazygit

    else
      LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
      curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
      # tar xf lazygit.tar.gz lazygit
      # sudo install lazygit /usr/local/bin
      tar xf lazygit.tar.gz -C "$HOME/.local/bin/"

    fi
  fi
fi
