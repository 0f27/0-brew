#!/bin/bash

if [[ $(uname -o) == "Darwin" ]]; then
	brew install helix

elif [[ $(uname -o) == "Android" ]]; then
  apt update
  apt install -y helix

else

  . /etc/os-release

  if [ "$ID" == "ubuntu" ]; then

    sudo add-apt-repository ppa:maveonair/helix-editor
    sudo apt update
    sudo apt install -y helix

  elif [ "$ID" = "fedora" ]; then
    dnf check-update
    sudo dnf install -y helix

  elif [ "$ID_LIKE" = "arch" ]; then
    sudo pacman -Sy --noconfirm helix

  else
    echo $ID not suppotred

  fi

fi
