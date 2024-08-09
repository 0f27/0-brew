#!/bin/bash

if ! command -v nvim &>/dev/null; then
  python3 -c "$(curl -sL https://raw.githubusercontent.com/XelorR/package-installer/main/package-installer)" neovim
fi

rm -rf ~/.config/kickstart ~/.local/share/kickstart
mkdir -p ~/.config/kickstart ~/.local/bin

cat <<'EOF' >~/.local/bin/kickstart
#!/usr/bin/env bash

NVIM_APPNAME=kickstart nvim $@
EOF
chmod +x ~/.local/bin/kickstart

git clone https://github.com/nvim-lua/kickstart.nvim ~/.config/kickstart
rm -rf ~/.config/kickstart/.git
