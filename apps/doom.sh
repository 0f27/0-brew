#!/usr/bin/env bash

if ! command -v emacs &>/dev/null; then
    if [[ $(uname -o) == "Darwin" ]]; then
        brew install emacs

    elif [[ $(uname -o) == "Android" ]]; then
      apt update
      apt install -y emacs

    else

        . /etc/os-release

        if [[ "$ID" == "fedora" && "$VARIANT_ID" != "silverblue" ]]; then
            dnf check-update
            sudo dnf install -y emacs

        elif [ "$ID_LIKE" = "opensuse suse" ]; then
            sudo zypper refresh
            sudo zypper --non-interactive install emacs

        elif [ "$ID_LIKE" = "debian" ]; then
            sudo apt update
            sudo apt install -y emacs

        elif [ "$ID_LIKE" = "arch" ]; then
            sudo pacman -Sy --noconfirm emacs

        fi
    fi
fi

if [ ! -f $HOME/.config/emacs/bin/doom ]; then
    mkdir -p $HOME/.config
    rm -rf $HOME/.emacs $HOME/.emacs.d $HOME/.config/emacs
    git clone --depth 1 https://github.com/doomemacs/doomemacs $HOME/.config/emacs
    $HOME/.config/emacs/bin/doom install --env -!
fi
