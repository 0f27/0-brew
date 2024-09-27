#!/usr/bin/env bash

if ! command -v lf &>/dev/null; then
  if command -v brew &>/dev/null; then
    brew install lf

  elif [[ $(uname -o) == "Android" ]]; then
    apt update
    apt install -y lf

  else
    . /etc/os-release

    if command -v pacman &>/dev/null; then
      sudo pacman -Sy --noconfirm lf

    else
      if [[ "$(uname -m)" == "x86_64" ]]; then
        URL="https://github.com/gokcehan/lf/releases/latest/download/lf-linux-amd64.tar.gz"
      elif [[ "$(uname -m)" == "aarch64" ]]; then
        URL="https://github.com/gokcehan/lf/releases/latest/download/lf-linux-arm64.tar.gz"
      fi
      archiveName="$(echo $URL | cut -d'/' -f9)"

      mkdir -p "$HOME/.local/bin"
      wget $URL
      tar xf $archiveName -C "$HOME/.local/bin/"
      rm -rf $archiveName
      sudo ln -s "$HOME/.local/bin/" /usr/bin/lf

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
