#!/usr/bin/env bash

if ! command -v lf &>/dev/null; then
	if [[ $(uname -o) == "Darwin" ]]; then
		brew install lf

	elif [[ $(uname -o) == "Android" ]]; then
		apt update
		apt install -y lf

	else
		. /etc/os-release

		if [ "$ID_LIKE" = "arch" ]; then
		    sudo pacman -Sy lf
		elif [[ "$(uname -m)" == "x86_64" ]]; then
			URL="https://github.com/gokcehan/lf/releases/latest/download/lf-linux-amd64.tar.gz"
		elif [[ "$(uname -m)" == "aarch64" ]]; then
			URL="https://github.com/gokcehan/lf/releases/latest/download/lf-linux-arm64.tar.gz"
		fi
		archiveName="$(echo $URL | cut -d'/' -f9)"

		mkdir -p "$HOME/.local/bin"
		rm -rf "$HOME/.local/bin/lf"
		wget $URL
		tar xf $archiveName -C "$HOME/.local/bin/"
		rm -rf $archiveName

	fi
fi
