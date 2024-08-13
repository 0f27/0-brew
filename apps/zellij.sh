#!/bin/sh

if ! command -v fish &>/dev/null; then
  echo No Zellij found, installing...

  if [[ $(uname -o) == "Darwin" ]]; then
    echo macOS detected
    brew install zellij

  elif [[ $(uname -o) == "Android" ]]; then
    echo Termux detected
    apt update
    apt install -y zellij

  else
    echo assuming GNU Linux

    . /etc/os-release
  
    if [ "$ID" = "fedora" ]; then
      dnf check-update
      sudo dnf copr enable varlad/zellij 
      sudo dnf install -y zellij

    elif [ "$ID_LIKE" = "arch" ]; then
      sudo pacman -Sy --noconfirm zellij

    else
      ARCHIVE="zellij-$(uname -m)-unknown-linux-musl.tar.gz"
      URL="https://github.com/zellij-org/zellij/releases/latest/download/$ARCHIVE"
      wget $URL
      mkdir -p $HOME/.local/bin
      tar xf $ARCHIVE -C "$HOME/.local/bin/"
      rm -rf $ARCHIVE

    fi
  fi
fi
