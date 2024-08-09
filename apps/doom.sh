#!/usr/bin/env sh

if ! command -v emacs &>/dev/null; then
    if [[ $(uname -o) == "Darwin" ]]; then
        brew install emacs

    elif [[ $(uname -o) == "Android" ]]; then
      apt update
      apt install -y emacs

    else

        . /etc/os-release

        if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
            sudo apt update
            sudo apt install -y emacs

        elif [ "$ID" = "fedora" ]; then
            dnf check-update
            sudo dnf install -y emacs

        elif [ "$ID" = "opensuse" ]; then
            sudo zypper refresh
            sudo zypper install emacs

        elif [ "$ID_LIKE" = "arch" ]; then
            sudo pacman -Sy --noconfirm emacs

        fi
    fi
fi

mkdir -p ~/.config
rm -rf ~/.emacs ~/.emacs.d ~/.config/emacs
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install --env -!
