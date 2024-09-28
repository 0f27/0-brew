#!/usr/bin/env bash

if ! command -v emacs &>/dev/null; then
  if command -v brew &>/dev/null; then
    brew install emacs

  elif [[ $(uname -o) == "Android" ]]; then
    apt update
    apt install -y emacs

  else

    . /etc/os-release

    if command -v pacman &>/dev/null; then
      sudo pacman -Sy --noconfirm emacs

    elif command -v rpm-ostree &>/dev/null; then
      sudo rpm-ostree install --apply-live -y emacs

    elif command -v zypper &>/dev/null; then
      sudo zypper refresh
      sudo zypper --non-interactive --no-confirm install emacs

    elif command -v dnf &>/dev/null; then
      dnf check-update
      sudo dnf install -y emacs

    elif command -v apt &>/dev/null; then
      sudo apt update
      sudo apt install -y emacs

    fi
  fi
fi

if [ ! -d ~/.config/emacs ] && [ ! -d ~/.emacs.d ] && [ ! -f ~/.emacs ]; then
  PATH="$HOME/.emacs.d/bin:$PATH"

  git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d

  mkdir ~/.doom.d
  cp ~/.emacs.d/init.example.el ~/.doom.d/init.el
  cp ~/.emacs.d/core/templates/config.example.el ~/.doom.d/config.el
  cp ~/.emacs.d/core/templates/packages.example.el ~/.doom.d/packages.el

  doom sync
  doom env

  emacs --batch -f nerd-icons-install-fonts

else
  echo Existing Emacs config found, skipping Doom installation

fi
