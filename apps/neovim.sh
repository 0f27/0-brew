#!/usr/bin/env bash

if [[ $(uname -o) == "Darwin" ]]; then
  brew install neovim

elif [[ $(uname -o) == "Android" ]]; then
	apt update
	apt install -y neovim

else

	if [[ "$ID" == "fedora" && "$VARIANT_ID" != "silverblue" ]]; then
    dnf check-update
    sudo dnf install -y neovim

	elif [ "$ID_LIKE" = "opensuse suse" ]; then
    sudo zypper refresh
    sudo zypper install neovim

	elif [ "$ID_LIKE" = "arch" ]; then
    sudo pacman -Sy --noconfirm neovim

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

			if ! grep -q '.local/bin' $HOME/.bashrc; then
				echo 'export PATH=$HOME/.local/bin:$PATH' >>$HOME/.bashrc
			fi
			if ! grep -q '.local/bin' $HOME/.zshrc; then
				echo 'export PATH=$HOME/.local/bin:$PATH' >>$HOME/.zshrc
			fi
		elif [[ "$(uname -m)" == "aarch64" ]]; then
			echo there is no NeoVim for GNU Linux aarch64 in official repo
			
		fi
	fi
fi
