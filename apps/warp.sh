#!/usr/bin/bash

if command -v brew &>/dev/null; then
  brew install --cask warp

elif [[ $(uname -o) == "Android" ]]; then
  echo there is no warp in termux

else

  . /etc/os-release

  if command -v pacman &>/dev/null; then
    wget 'https://app.warp.dev/download?package=pacman' -O warp.pkg.tar.zst
    sudo pacman -U ./warp.pkg.tar.zst
    rm warp.pkg.tar.zst

  elif command -v dnf &>/dev/null; then
    sudo rpm --import https://releases.warp.dev/linux/keys/warp.asc
    sudo sh -c 'echo -e "[warpdotdev]\nname=warpdotdev\nbaseurl=https://releases.warp.dev/linux/rpm/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://releases.warp.dev/linux/keys/warp.asc" > /etc/yum.repos.d/warpdotdev.repo'
    sudo dnf install -y warp-terminal

  elif command -v apt &>/dev/null; then
    sudo apt-get install -y wget gpg
    wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --dearmor >warpdotdev.gpg
    sudo install -D -o root -g root -m 644 warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" > /etc/apt/sources.list.d/warpdotdev.list'
    rm warpdotdev.gpg
    sudo apt update && sudo apt install warp-terminal

  else
    echo currently not implemented for $ID

  fi
fi
