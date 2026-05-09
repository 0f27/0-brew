#!/usr/bin/env sh

if command -v aria2c &>/dev/null; then
  TOOL=aria2c
elif command -v wget &>/dev/null; then
  TOOL=wget
elif command -v curl &>/dev/null; then
  TOOL="curl -LO"
fi

PACKAGE=Miniforge3-$(uname)-$(uname -m).sh
BASE_URL="https://github.com/conda-forge/miniforge/releases/latest/download"
INSTALL_LOCATION="$HOME/.condaforge"

if ! test -f "$INSTALL_LOCATION/bin/activate"; then
  $TOOL $BASE_URL/$PACKAGE
  bash $PACKAGE -b -p $INSTALL_LOCATION && rm $PACKAGE
fi
