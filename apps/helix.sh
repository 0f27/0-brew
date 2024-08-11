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
C-g = [":new", ":insert-output lazygit", ":buffer-close!", ":redraw", ":reload-all"]
EOF

# setting as default editor
if ! grep -q 'set -Ux EDITOR hx' $HOME/.config/fish/config.fish; then
  mkdir -p $HOME/.config/fish
  echo 'set -Ux EDITOR hx' >> $HOME/.config/fish/config.fish
  echo 'set -Ux VISUAL hx' >> $HOME/.config/fish/config.fish
fi

if ! grep -q 'export EDITOR=hx' $HOME/.zshrc; then
  echo 'export EDITOR=hx' >> $HOME/.zshrc
  echo 'export VISUAL=hx' >> $HOME/.zshrc
fi

if ! grep -q 'export EDITOR=hx' $HOME/.bashrc; then
  echo 'export EDITOR=hx' >> $HOME/.bashrc
  echo 'export VISUAL=hx' >> $HOME/.bashrc
fi
