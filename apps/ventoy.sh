#!/bin/bash

if [[ $(uname -o) == "Darwin" ]]; then
  echo there is no ventoy on macos
elif [[ $(uname -o) == "Android" ]]; then
  echo there is no ventoy in termux


else

  # get link and set variables
  VERSION="$(curl -sL https://github.com/ventoy/Ventoy/releases | grep -E 'Ventoy .* release' | cut -d ' ' -f 6 | head -n 1)"
  ARCHIVE="ventoy-"$VERSION"-linux.tar.gz"
  OPTIONAL_SOFTWARE_FOLDER="$HOME/.opt"
  URL="https://github.com/ventoy/Ventoy/releases/download/v"$VERSION"/$ARCHIVE"
  EXTRACT_FOLDER="$(echo $ARCHIVE | sed 's/.tar.gz$//')"

  # download
  mkdir -p "$OPTIONAL_SOFTWARE_FOLDER"
  if command -v aria2c &>/dev/null; then
  	aria2c $URL
  elif command -v wget &>/dev/null; then
  	wget $URL
  elif command -v curl &>/dev/null; then
  	curl -LO $URL
  fi

  # unpack
  tar xzf "$ARCHIVE" -C "$OPTIONAL_SOFTWARE_FOLDER"
  rm "$ARCHIVE"

fi
