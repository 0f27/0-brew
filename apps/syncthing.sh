#!/usr/bin/env bash

if [[ $(uname -o) == "Darwin" ]]; then
    brew install syncthing

elif [[ $(uname -o) == "Android" ]]; then
	apt update
	apt install -y syncthing

else

    . /etc/os-release

    if [[ "$ID" == "fedora" && "$VARIANT_ID" != "silverblue" ]]; then
        dnf check-update
        sudo dnf install -y syncthing

    elif [ "$ID" = "opensuse" ]; then
        sudo zypper refresh
        sudo zypper install syncthing

    elif [[ "ID" == "ubuntu" || "ID" == "debian" || "$ID_LIKE" == "debian" || "$ID_LIKE" == "ubuntu debian" ]]; then
        sudo apt install -y curl

        # Add the release PGP keys:
        sudo mkdir -p /etc/apt/keyrings
        sudo curl -L -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg

        # Add the "stable" channel to your APT sources:
        echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

        # Update and install syncthing:
        sudo apt-get update
        sudo apt-get install -y syncthing

    elif [ "$ID_LIKE" = "arch" ]; then
        sudo pacman -Sy --noconfirm syncthing

    fi

fi
