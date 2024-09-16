#!/bin/bash

if [[ $(uname -o) == "Darwin" ]]; then
  echo currently not implemented for macos
elif [[ $(uname -o) == "Android" ]]; then
  echo there is no nekoray in termux

else
  VERSION="$(curl -sL https://github.com/MatsuriDayo/nekoray/releases | grep '/MatsuriDayo/nekoray/releases/tag/' | cut -d'"' -f6 | head -n 1 | cut -d'/' -f6)"
  APPIMAGE_NAME="$(curl -sL https://github.com/MatsuriDayo/nekoray/releases/expanded_assets/$VERSION | grep AppImage | cut -d'"' -f2 | head -n1 | cut -d'/' -f7)"
  DOWNLOAD_URL="https://github.com/MatsuriDayo/nekoray/releases/download/$VERSION/$APPIMAGE_NAME"

  if command -v aria2c &>/dev/null; then
    aria2c $DOWNLOAD_URL
  elif command -v wget &>/dev/null; then
    wget $DOWNLOAD_URL
  elif command -v curl &>/dev/null; then
    curl -LO $DOWNLOAD_URL
  fi
  mkdir -p "$HOME/.opt"
  mv "$APPIMAGE_NAME" "$HOME/.opt/$APPIMAGE_NAME"
  chmod +x "$HOME/.opt/$APPIMAGE_NAME"

fi
