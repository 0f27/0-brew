#!/bin/sh

if ! command -v serpl &>/dev/null; then
  if [[ $(uname -o) == "Darwin" ]]; then
  	brew install serpl

  elif [[ $(uname -o) == "Android" ]]; then
    echo serpl is not available for termux

  else

    . /etc/os-release

    if [ "$ID_LIKE" = "arch" ]; then
      sudo pacman -Sy --noconfirm serpl

    else
      VERSION="$(curl -sL https://github.com/yassinebridi/serpl/releases | grep '/yassinebridi/serpl/releases/download/' | head -n 1 | cut -d '/' -f6)"
  		if [[ "$(uname -m)" == "x86_64" ]]; then
  		  ARCH="x86_64"
  		elif [[ "$(uname -m)" == "aarch64" ]]; then
    		ARCH="arm64"
  		fi
    	ARCHIVE="serpl-$VERSION-linux-$ARCH.tar.gz"
    	URL="https://github.com/yassinebridi/serpl/releases/download/$VERSION/$ARCHIVE"
    	wget $URL
    	mkdir -p "$HOME/.local/bin"
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
  echo "set -a fish_user_paths $HOME/.local/bin" >> $HOME/.config/fish/config.fish
fi
