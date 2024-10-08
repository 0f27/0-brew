#!/usr/bin/env bash

if [[ $(uname -o) == "Darwin" ]]; then
  brew install --cask neovide
elif [[ $(uname -o) == "Android" ]]; then
  echo neovide is not available for termux

else

  . /etc/os-release

  if command -v pacman &>/dev/null; then
    sudo pacman -Sy neovide

  elif command -v dnf &>/dev/null; then
    sudo dnf install -y fontconfig-devel freetype-devel libX11-xcb libX11-devel libstdc++-static libstdc++-devel
    sudo dnf groupinstall -y "Development Tools" "Development Libraries"
    curl --proto '=https' --tlsv1.2 -sSf "https://sh.rustup.rs" | sh
    cargo install --git https://github.com/neovide/neovide

  elif command -v apt &>/dev/null; then
    sudo apt install -y curl \
      gnupg ca-certificates git \
      gcc-multilib g++-multilib cmake libssl-dev pkg-config \
      libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev \
      libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libfontconfig1-dev \
      libxcursor-dev
    curl --proto '=https' --tlsv1.2 -sSf "https://sh.rustup.rs" | sh
    cargo install --git https://github.com/neovide/neovide

  fi
fi
