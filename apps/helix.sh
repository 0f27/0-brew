#!/bin/bash

# installing Helix itself, if not available
if ! command -v hx &>/dev/null; then
  if [[ $(uname -o) == "Darwin" ]]; then
  	brew install helix

  elif [[ $(uname -o) == "Android" ]]; then
    apt update
    apt install -y helix

  else

    . /etc/os-release

    if [[ "$ID" == "fedora" && "$VARIANT_ID" != "silverblue" && "$VARIANT_ID" != "kinoite" ]]; then
      dnf check-update
      sudo dnf install -y helix

    elif [[ "$ID" == "ubuntu" || "$ID_LIKE" == "ubuntu debian" ]]; then

      sudo add-apt-repository ppa:maveonair/helix-editor
      sudo apt update
      sudo apt install -y helix

    elif [ "$ID_LIKE" = "arch" ]; then
      sudo pacman -Sy --noconfirm helix
      sudo ln -s /usr/bin/helix /usr/bin/hx

    else
      VERSION="$(curl -sL https://github.com/helix-editor/helix/releases | grep 'helix/releases/expanded_assets' | head -n1 | cut -d '"' -f 6 | cut -d '/' -f8)"
      ARCH="$(uname -m)"
    	ARCHIVE="helix-$VERSION-$ARCH-linux.tar.xz"
    	EXTRACTION_FOLDER="$(echo $ARCHIVE | sed 's/.tar.xz$//')"
    	URL="https://github.com/helix-editor/helix/releases/download/$VERSION/$ARCHIVE"
    	wget $URL

    	mkdir -p "$HOME/.local/bin" "$HOME/.opt" "$HOME/.config/helix"
      tar xf $ARCHIVE -C "$HOME/.opt"
      ln -s "$HOME/.opt/$EXTRACTION_FOLDER/hx" "$HOME/.local/bin/hx"
      ln -s "$HOME/.opt/$EXTRACTION_FOLDER/runtime" "$HOME/.config/helix/runtime"
      rm -rf $ARCHIVE

      sudo mkdir /root/.config/helix
      sudo ln -s "$HOME/.opt/$EXTRACTION_FOLDER/runtime" /root/.config/helix/runtime
      sudo ln -s "$HOME/.opt/$EXTRACTION_FOLDER/hx" /usr/bin/hx

    fi
  fi
fi


# setting as default editor
# EDITOR
if ! grep -q 'set -Ux EDITOR' $HOME/.config/fish/config.fish; then
  mkdir -p $HOME/.config/fish
  echo 'set -Ux EDITOR hx' >> $HOME/.config/fish/config.fish
fi

if ! grep -q 'export EDITOR' $HOME/.zshrc; then
  echo 'export EDITOR=hx' >> $HOME/.zshrc
fi

if ! grep -q 'export EDITOR' $HOME/.bashrc; then
  echo 'export EDITOR=hx' >> $HOME/.bashrc
fi

# VISUAL
if ! grep -q 'set -Ux VISUAL' $HOME/.config/fish/config.fish; then
  mkdir -p $HOME/.config/fish
  echo 'set -Ux VISUAL hx' >> $HOME/.config/fish/config.fish
fi

if ! grep -q 'export VISUAL' $HOME/.zshrc; then
  echo 'export VISUAL=hx' >> $HOME/.zshrc
fi

if ! grep -q 'export VISUAL' $HOME/.bashrc; then
  echo 'export VISUAL=hx' >> $HOME/.bashrc
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

# adding basic example config
mkdir -p ~/.config/helix

cat <<'EOF' >~/.config/helix/config.toml
theme="dark_plus"

[editor.cursor-shape]
insert = "bar"

[editor]
bufferline = "multiple"
cursorline = true
true-color = true

[keys.normal]
A-z = [ ":toggle-option soft-wrap.enable", ":redraw" ]

[keys.normal.'space'.'space']
g = [":new", ":insert-output lazygit", ":buffer-close!", ":redraw", ":reload-all"]
EOF

