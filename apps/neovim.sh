#!/usr/bin/env bash

if [[ $(uname -o) == "Darwin" ]]; then
  if command -v brew &>/dev/null; then
    brew install neovim
  else
    echo brew not found, binary download for mac not implemented...
  fi

elif [[ $(uname -o) == "Android" ]]; then
  apt update
  apt install -y neovim

else
  . /etc/os-release

  if command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm neovim

  elif command -v rpm-ostree &>/dev/null; then
    sudo rpm-ostree install --apply-live -y neovim

  elif command -v zypper &>/dev/null; then
    sudo zypper refresh
    sudo zypper --non-interactive --no-confirm install neovim

  elif command -v dnf &>/dev/null; then
    dnf check-update
    sudo dnf install -y neovim

  elif [[ "$ID" == "ubuntu" || "$ID_LIKE" == "ubuntu debian" ]]; then
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt update
    sudo apt install -y neovim

  else
    if [[ "$(uname -m)" == "x86_64" ]]; then
      URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
      if command -v aria2c &>/dev/null; then
        aria2c $URL
      elif command -v wget &>/dev/null; then
        wget $URL
      elif command -v curl &>/dev/null; then
        curl -LO $URL
      fi
      mkdir -p $HOME/.opt $HOME/.local/bin
      rm -rf $HOME/.opt/nvim-linux64

      tar -C $HOME/.opt -xzf nvim-linux64.tar.gz
      rm -rf nvim-linux64.tar.gz

      rm -rf $HOME/.local/bin/nvim
      ln -s $HOME/.opt/nvim-linux64/bin/nvim $HOME/.local/bin/nvim
      sudo ln -s $HOME/.opt/nvim-linux64/bin/nvim /bin/nvim

      if ! grep -q '.local/bin' $HOME/.bashrc; then
        echo 'export PATH=$HOME/.local/bin:$PATH' >>$HOME/.bashrc
      fi
      if ! grep -q '.local/bin' $HOME/.zshrc; then
        echo 'export PATH=$HOME/.local/bin:$PATH' >>$HOME/.zshrc
      fi
      if ! grep -q '.local/bin' $HOME/.config/fish/config.fish; then
        mkdir -p $HOME/.config/fish
        echo "set -a fish_user_paths $HOME/.local/bin" >>$HOME/.config/fish/config.fish
      fi

    elif [[ "$(uname -m)" == "aarch64" ]]; then
      if command -v snap &>/dev/null; then
        sudo snap install nvim --classic
      else
        echo there is no NeoVim for GNU Linux aarch64 in official repo
      fi

    fi
  fi
fi
