#!/usr/bin/env bash

if ! command -v emacs &>/dev/null; then
  if command -v brew &>/dev/null; then
    brew install emacs git ripgrep fd

  elif [[ $(uname -o) == "Android" ]]; then
    apt update
    apt install -y emacs git ripgrep fd

  else

    . /etc/os-release

    if command -v pacman &>/dev/null; then
      sudo pacman -Sy --noconfirm emacs git ripgrep fd

    elif command -v rpm-ostree &>/dev/null; then
      sudo rpm-ostree install --apply-live -y emacs git ripgrep fd-find

    elif command -v zypper &>/dev/null; then
      sudo zypper refresh
      sudo zypper --non-interactive --no-confirm install emacs git ripgrep fd-find

    elif command -v dnf &>/dev/null; then
      dnf check-update
      sudo dnf install -y emacs git ripgrep fd-find

    elif command -v snap &>/dev/null; then
      sudo snap instal emacs --classic
      sudo snap instal ripgrep --classic

    elif command -v apt &>/dev/null; then
      sudo apt update
      sudo apt install -y emacs ripgrep git fd-find

    fi
  fi
fi

if [ ! -d ~/.config/emacs ] && [ ! -d ~/.emacs.d ] && [ ! -f ~/.emacs ]; then
  PATH="$HOME/.emacs.d/bin:$PATH"

  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
  ~/.emacs.d/bin/doom install --force --fonts --env

else
  echo Existing Emacs config found, skipping Doom installation

fi
