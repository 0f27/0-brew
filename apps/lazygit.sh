#!/usr/bin/env bash

if ! command -v lazygit &>/dev/null; then
  if [[ $(uname -o) == "Darwin" ]]; then
  	brew install lazygit

  elif [[ $(uname -o) == "Android" ]]; then
    apt update
    apt install -y lazygit

  else
		. /etc/os-release

	if [[ "$ID" == "fedora" && "$VARIANT_ID" != "silverblue" && "$VARIANT_ID" != "kinoite" ]]; then
		sudo dnf copr enable atim/lazygit -y
		sudo dnf install -y lazygit
	elif [ "$ID_LIKE" = "arch" ]; then
	    sudo pacman -Sy lazygit
	else
		LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
		# tar xf lazygit.tar.gz lazygit
		# sudo install lazygit /usr/local/bin
    tar xf lazygit.tar.gz -C "$HOME/.local/bin/"
	fi
fi
