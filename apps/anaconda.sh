#!/usr/bin/env sh

if [[ $(uname -o) == "Darwin" ]]; then
	brew install --cask anaconda

elif [[ $(uname -o) == "Android" ]]; then
	echo termux version currently not implemented

else
  PACKAGE=$(curl -sL https://repo.anaconda.com/archive/ | grep Anaconda3 | grep Linux | grep "$(uname -m)" | head -n 1 | cut -d\" -f2)
	if ! test -f "$HOME/.anaconda3/bin/activate"; then
		if command -v aria2c &>/dev/null; then
			TOOL=aria2c
		elif command -v wget &>/dev/null; then
			TOOL=wget
    elif command -v curl &>/dev/null; then
      TOOL="curl -LO"
    fi
    $TOOL https://repo.anaconda.com/archive/$PACKAGE && bash $PACKAGE -b -p ~/.anaconda3 && rm $PACKAGE
	fi
fi
