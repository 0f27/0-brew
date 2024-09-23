#!/bin/bash

# installing Helix itself, if not available
if ! command -v hx &>/dev/null; then
  if command -v brew &>/dev/null; then
    brew install helix

  elif [[ $(uname -o) == "Android" ]]; then
    apt update
    apt install -y helix

  else
    if [[ $(uname -o) == "Darwin" ]]; then
      OS="macos"
    else
      OS="linux"
      . /etc/os-release
    fi

    if command -v pacman &>/dev/null; then
      sudo pacman -Sy --noconfirm helix
      sudo ln -s /usr/bin/helix /usr/bin/hx

    elif command -v dnf &>/dev/null; then
      dnf check-update
      sudo dnf install -y helix

    elif [[ "$ID" == "ubuntu" || "$ID_LIKE" == "ubuntu debian" ]]; then

      sudo add-apt-repository ppa:maveonair/helix-editor -y
      sudo apt update
      sudo apt install -y helix

    else

      VERSION="$(curl -sL https://github.com/helix-editor/helix/releases | grep 'helix/releases/expanded_assets' | head -n1 | cut -d '"' -f 6 | cut -d '/' -f8)"
      ARCH="$(uname -m)"
      ARCHIVE="helix-$VERSION-$ARCH-$OS.tar.xz"
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
  echo 'set -Ux EDITOR hx' >>$HOME/.config/fish/config.fish
fi

if ! grep -q 'export EDITOR' $HOME/.zshrc; then
  echo 'export EDITOR=hx' >>$HOME/.zshrc
fi

if ! grep -q 'export EDITOR' $HOME/.bashrc; then
  echo 'export EDITOR=hx' >>$HOME/.bashrc
fi

# VISUAL
if ! grep -q 'set -Ux VISUAL' $HOME/.config/fish/config.fish; then
  mkdir -p $HOME/.config/fish
  echo 'set -Ux VISUAL hx' >>$HOME/.config/fish/config.fish
fi

if ! grep -q 'export VISUAL' $HOME/.zshrc; then
  echo 'export VISUAL=hx' >>$HOME/.zshrc
fi

if ! grep -q 'export VISUAL' $HOME/.bashrc; then
  echo 'export VISUAL=hx' >>$HOME/.bashrc
fi

if ! grep -q '.local/bin' $HOME/.zshrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >>$HOME/.zshrc
fi
if ! grep -q '.local/bin' $HOME/.bashrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >>$HOME/.bashrc
fi
if ! grep -q '.local/bin' $HOME/.config/fish/config.fish; then
  mkdir -p $HOME/.config/fish
  echo "set -a fish_user_paths $HOME/.local/bin" >>$HOME/.config/fish/config.fish
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
H = [ ":buffer-previous" ]
L = [ ":buffer-next" ]
A-z = [ ":toggle-option soft-wrap.enable", ":redraw" ]
A-r = [ ":reload-all", ":config-reload", ":redraw" ]
C-space = [ "expand_selection" ]
backspace = [ "shrink_selection" ]

[keys.normal.'space'.'space']
w = [":write", ":redraw"]
g = [":new", ":insert-output lazygit", ":buffer-close!", ":redraw", ":reload-all"]
EOF
