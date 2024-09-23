#!/usr/bin/env bash

if command -v brew &>/dev/null; then
  brew install syncthing

elif [[ $(uname -o) == "Android" ]]; then
  apt update
  apt install -y syncthing

else

  . /etc/os-release

  if command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm syncthing

  elif command -v rpm-ostree &>/dev/null; then
    sudo rpm-ostree install --apply-live -y syncthing

  elif command -v zypper &>/dev/null; then
    sudo zypper refresh
    sudo zypper --non-interactive --no-confirm install syncthing

  elif command -v dnf &>/dev/null; then
    dnf check-update
    sudo dnf install -y syncthing

  elif command -v apt &>/dev/null; then
    sudo apt install -y curl

    # Add the release PGP keys:
    sudo mkdir -p /etc/apt/keyrings
    sudo curl -L -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg

    # Add the "stable" channel to your APT sources:
    echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

    # Update and install syncthing:
    sudo apt-get update
    sudo apt-get install -y syncthing

  fi

fi
