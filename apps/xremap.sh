#!/bin/bash

if [[ $(uname -o) == "Darwin" ]]; then
  echo Xremap is not supported on macOS

elif [[ $(uname -o) == "Android" ]]; then
  echo Xremap is not supported in Termux

else

  # download the binary
  if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" || "$XDG_CURRENT_DESKTOP" == "ubuntu:GNOME" ]]; then
    platform="gnome"
  elif [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
    platform="kde"
  elif [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
    platform="wlroots"
  else
    platform="x11"
  fi
  xremap_url=$(curl -sL https://api.github.com/repos/k0kubun/xremap/releases/latest | grep x86_64-$platform.zip | grep browser | cut -d'"' -f4)
  xremap_name=$(echo $xremap_url | cut -d'/' -f9)
  wget $xremap_url
  mkdir -p $HOME/.local/bin/
  7z x $xremap_name -O$HOME/.local/bin/
  rm $xremap_name

  # Create basic config if not exists
  if [ ! -e $HOME/.config/xremap/config.yml ]; then
    mkdir -p $HOME/.config/xremap
    cat <<CONFIG >$HOME/.config/xremap/config.yml
shared:
  notepads: &notepads
    - kate
    - TextEditor

modmap:
  - name: Modifiers
    remap:
      Alt_L: Super_L
      Super_L: Alt_L
      Ctrl_L: Super-space
        held: Ctrl_L
        alone: Super-space
      CapsLock:
        held: Ctrl_R
        alone: Esc
      Space:
        held: Ctrl_R
        alone: Space

keymap:
  - name: Notepads
    application:
      only: *notepads
    remap:
      Super-Backspace: [Shift-home, Backspace]
      Super-Delete: [Shift-end, Delete]
CONFIG
  fi

  # Create systemd service file
  mkdir -p $HOME/.config/systemd/user
  XREMAP_PATH="$HOME/.local/bin/xremap"
  cat <<SERVICE >$HOME/.config/systemd/user/xremap.service
[Unit]
Description=Xremap Service
[Service]
ExecStart=$XREMAP_PATH --watch $HOME/.config/xremap/config.yml
[Install]
WantedBy=default.target
SERVICE

  systemctl --user daemon-reload
  # systemctl enable --now --user xremap

  # adding user to input group, to avoid using sudo
  . /etc/os-release
  sudo gpasswd -a $USER input
  if [[ "ID" == "ubuntu" || "ID" == "debian" || "$ID_LIKE" == "debian" || "$ID_LIKE" == "ubuntu debian" ]]; then
    echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/input.rules
  elif [ "$ID_LIKE" = "arch" ]; then
    echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/99-input.rules
  else
    echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/input.rules
  fi
  echo udev rule added, you may need to reboot

fi
