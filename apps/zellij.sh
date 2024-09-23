#!/bin/sh

if ! command -v zellij &>/dev/null; then
  echo No Zellij found, installing...

  if command -v brew &>/dev/null; then
    brew install zellij

  elif [[ $(uname -o) == "Android" ]]; then
    apt update
    apt install -y zellij

  else

    . /etc/os-release
  
    if command -v pacman &>/dev/null; then
        sudo pacman -Sy --noconfirm zellij

    elif command -v dnf &>/dev/null; then
        dnf check-update
        sudo dnf copr enable varlad/zellij 
        sudo dnf install -y zellij

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
