#!/usr/bin/env sh

if [[ $(uname -o) == "Darwin" ]]; then
	brew install --cask anaconda

elif [[ $(uname -o) == "Android" ]]; then
	echo termux version currently not implemented

else
	if ! test -f "$HOME/.anaconda3/bin/activate"; then
		VERSION="$(curl -sL https://formulae.brew.sh/cask/anaconda | grep 'Current version' | cut -d'>' -f3 | cut -d'<' -f1)"
		if command -v aria2c &>/dev/null; then
			aria2c https://repo.anaconda.com/archive/Anaconda3-$VERSION-Linux-x86_64.sh && bash Anaconda3* -b -p ~/.anaconda3 && rm Anaconda3*
		elif command -v wget &>/dev/null; then
			wget https://repo.anaconda.com/archive/Anaconda3-$VERSION-Linux-x86_64.sh && bash Anaconda3* -b -p ~/.anaconda3 && rm Anaconda3*
		fi
	fi
fi
