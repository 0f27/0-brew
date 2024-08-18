#!/usr/bin/env bash

if command -v curl &>/dev/null; then
  
  if [[ $(uname -o) == "Darwin" ]]; then
    brew install chezmoi

  elif [[ $(uname -o) == "Android" ]]; then
    apt update
    apt install -y chezmoi

  else

    . /etc/os-release

    if [ "$ID_LIKE" = "arch" ]; then
      pacman -Sy chezmoi

    elif [ "$ID_LIKE" = "opensuse suse" ]; then
      sudo zypper refresh
      sudo zypper --non-interactive install chezmoi

    elif command -v curl &>/dev/null; then
      sh -c "$(curl -fsLS get.chezmoi.io)"

    elif command -v curl &>/dev/null; then
      sh -c "$(wget -qO- get.chezmoi.io)"

    fi
  fi

fi
