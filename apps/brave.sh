#!/usr/bin/env bash

if command -v brew &>/dev/null; then
  brew install --cask brave-browser

elif [[ $(uname -o) == "Android" ]]; then
  echo termux version currently not implemented

else

  . /etc/os-release

  if command -v pacman &>/dev/null; then
    paru -Sy brave-bin

  elif command -v zypper &>/dev/null; then
    sudo zypper --non-interactive --no-confirm install curl
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

    sudo zypper --non-interactive --no-confirm install brave-browser

  elif command -v dnf &>/dev/null; then
    sudo dnf install dnf-plugins-core
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

    sudo dnf install -y brave-browser

  elif command -v apt &>/dev/null; then
    sudo apt install -y curl
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

    sudo apt update
    sudo apt install -y brave-browser

  fi
fi
