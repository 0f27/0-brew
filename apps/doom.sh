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

  wget https://github.com/doomemacs/doomemacs/archive/refs/heads/master.tar.gz
  tar -xf master.tar.gz
  mv doomemacs-master ~/.emacs.d
  rm master.tar.gz

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
