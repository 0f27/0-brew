#!/bin/bash

if [[ $(uname -o) == "Darwin" ]]; then
  echo there is no ventoy on macos
elif [[ $(uname -o) == "Android" ]]; then
  echo there is no ventoy in termux


else

  # get link and set variables
  VERSION="$(curl -sL https://github.com/ventoy/Ventoy/releases | grep -E 'Ventoy .* release' | cut -d ' ' -f 6 | head -n 1)"
  FILE="ventoy-"$VERSION"-linux.tar.gz"
  FOLDER="$HOME/.opt"
  URL="https://github.com/ventoy/Ventoy/releases/download/v"$VERSION"/$FILE"
  EXTRACT_FOLDER="$(echo $FILE | sed 's/.tar.gz$//')"

  # download
  rm -rf "$FOLDER/$FILE"
  mkdir -p "$FOLDER"
  if command -v aria2c &>/dev/null; then
  	aria2c $URL
  elif command -v wget &>/dev/null; then
  	wget $URL
  elif command -v curl &>/dev/null; then
  	curl -LO $URL
  fi

  # unpack
  tar xzf "$FOLDER/$FILE" -C "$FOLDER/$EXTRACT_FOLDER"

fi
