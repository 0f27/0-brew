#!/bin/bash

if [ "$(uname)" = "Darwin" ]; then
	FONTS=$HOME/Library/Fonts
else
	FONTS=$HOME/.fonts
fi

URL="https://github.com/xelorr/SFMono-Nerd-Font-Ligaturized/releases/latest/download/sf.tar.xz"
if command -v aria2c &>/dev/null; then
	aria2c $URL
elif command -v wget &>/dev/null; then
	wget $URL
elif command -v curl &>/dev/null; then
	curl -LO $URL
fi

mkdir -p $FONTS
tar xvf sf.tar.xz -C $FONTS/
rm sf.tar.xz
