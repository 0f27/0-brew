#!/bin/bash

if command -v brew &>/dev/null; then
  brew install --cask zed

else
  . /etc/os-release

  if [ "$ID_LIKE" = "arch" ]; then
    sudo pacman -Sy --noconfirm lf
  else
    curl -f https://zed.dev/install.sh | sh
  fi

fi
