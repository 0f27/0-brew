#!/bin/sh

if ! command -v serpl &>/dev/null; then
  if [[ $(uname -o) == "Darwin" ]]; then
  	brew install serpl

  elif [[ $(uname -o) == "Android" ]]; then
    echo serpl is not available for termux

  else

    . /etc/os-release

    if [ "$ID_LIKE" = "arch" ]; then
      sudo pacman -Sy --noconfirm serpl

    else to be implemented for $ID

    fi
  fi
fi
