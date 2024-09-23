#!/bin/bash

if command -v brew &>/dev/null; then
  brew install --cask zed

else
  . /etc/os-release

  if command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm lf

  elif command -v flatpak &>/dev/null; then
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub dev.zed.Zed

  else
    curl -f https://zed.dev/install.sh | sh

  fi

fi
