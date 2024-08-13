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

    if [ "$ID" == "ubuntu" ]; then

      sudo add-apt-repository ppa:maveonair/helix-editor
      sudo apt update
      sudo apt install -y helix

    elif [ "$ID" = "fedora" ]; then
      dnf check-update
      sudo dnf install -y helix

    elif [ "$ID_LIKE" = "arch" ]; then
      sudo pacman -Sy --noconfirm helix
      sudo ln -s /usr/bin/helix /usr/bin/hx

    else
      echo $ID not suppotred

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

# adding basic example config
mkdir -p ~/.config/helix

cat <<'EOF' >~/.config/helix/config.toml
theme="dark_plus"

[editor.cursor-shape]
insert = "bar"

[editor]
bufferline = "multiple"
cursorline = true

[keys.insert]
j = { j = "normal_mode" }

[keys.normal]
#like c-d in vscode
"C-n" = [
  "move_prev_word_start",
  "move_next_word_end",
  "search_selection",
  "extend_search_next",
]
A-z = [ ":toggle-option soft-wrap.enable", ":redraw" ]

[keys.normal.'space'.'space']
g = [":new", ":insert-output lazygit", ":buffer-close!", ":redraw", ":reload-all"]
EOF

