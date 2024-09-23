#!/usr/bin/env bash

if [[ $(uname -o) == "Darwin" ]]; then
  echo Qe is not supported on macOS

elif [[ $(uname -o) == "Android" ]]; then
  echo Qe is not supported in Termux

else
  . /etc/os-release

  # installing pre-requisites

  if command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm \
      wget \
      qemu-desktop \
      cdrkit

  elif command -v rpm-ostree &>/dev/null; then
    sudo rpm-ostree install --apply-live -y \
      wget \
      edk2-ovmf \
      qemu-{kvm,tools} \
      genisoimage

  elif command -v dnf &>/dev/null; then
    sudo dnf install -y \
      wget \
      edk2-ovmf \
      qemu-{kvm,tools} \
      genisoimage

  elif [[ "$ID" == "ubuntu" || "$ID_LIKE" == "ubuntu debian" ]]; then
    sudo apt install -y \
      wget \
      qemu-kvm \
      genisoimage

  elif [[ "$ID" == "debian" || "$ID" == "kali" ]]; then
    sudo apt update
    sudo apt install -y \
      wget \
      qemu-{user,system{,-gui},utils} \
      genisoimage

  fi

  # copying script itself
  mkdir -p ~/.local/bin
  wget https://raw.githubusercontent.com/XelorR/qe/main/qe -O ~/.local/bin/qe
  chmod +x ~/.local/bin/qe

  # ensuring that it's in PATH
  if ! grep -q '.local/bin' $HOME/.bashrc; then
    echo 'export PATH=$HOME/.local/bin:$PATH' >>$HOME/.bashrc
  fi
  if ! grep -q '.local/bin' $HOME/.zshrc; then
    echo 'export PATH=$HOME/.local/bin:$PATH' >>$HOME/.zshrc
  fi
fi
