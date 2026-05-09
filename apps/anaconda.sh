#!/usr/bin/env sh

if command -v aria2c &>/dev/null; then
  TOOL=aria2c
elif command -v wget &>/dev/null; then
  TOOL=wget
elif command -v curl &>/dev/null; then
  TOOL="curl -LO"
fi

PACKAGE=$(curl -sL https://repo.anaconda.com/archive/ | grep Anaconda3 | grep $(uname) | grep "$(uname -m)" | head -n 1 | cut -d\" -f2)
BASE_URL="https://repo.anaconda.com/archive"
INSTALL_LOCATION="$HOME/.anaconda"

if ! test -f "$INSTALL_LOCATION/bin/activate"; then
  $TOOL $BASE_URL/$PACKAGE
  bash $PACKAGE -b -p $INSTALL_LOCATION && rm $PACKAGE
fi
