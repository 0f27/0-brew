#!/usr/bin/env bash

if [[ $(uname -o) == "Darwin" ]]; then
    brew install --cask visual-studio-code

elif [[ $(uname -o) == "Android" ]]; then
	echo termux version currently not implemented

else

    . /etc/os-release

    if [[ "$ID" == "fedora" && "$VARIANT_ID" != "silverblue" ]]; then
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

        dnf check-update
        sudo dnf install -y code

    elif [ "$ID_LIKE" = "opensuse suse" ]; then
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'

        sudo zypper refresh
        sudo zypper --non-interactive install code

    elif [[ "ID" == "ubuntu" || "ID" == "debian" || "$ID_LIKE" == "debian" || "$ID_LIKE" == "ubuntu debian" ]]; then
        sudo apt-get install -y wget gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        rm -f packages.microsoft.gpg

        sudo apt install -y apt-transport-https
        sudo apt update
        sudo apt install -y code

    elif [ "$ID_LIKE" = "arch" ]; then
        paru -Sy --noconfirm visual-studio-code-bin

    else
        echo currently not implemented for $ID

    fi
fi
