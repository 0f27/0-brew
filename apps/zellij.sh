#!/bin/sh

if ! command -v zellij &>/dev/null; then
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
  
    if [[ "$ID" == "fedora" && "$VARIANT_ID" != "silverblue" && "$VARIANT_ID" != "kinoite" ]]; then
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

if ! grep -q '.local/bin' $HOME/.zshrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.zshrc
fi
if ! grep -q '.local/bin' $HOME/.bashrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bashrc
fi
if ! grep -q '.local/bin' $HOME/.config/fish/config.fish; then
  mkdir -p $HOME/.config/fish
  echo "set -a fish_user_paths $HOME/.local/bin" >> $HOME/.config/fish/config.fish
fi
