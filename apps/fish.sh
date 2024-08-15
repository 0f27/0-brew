#!/usr/bin/env bash

if ! command -v fish &>/dev/null; then
  echo No fish found, installing...

  if [[ $(uname -o) == "Darwin" ]]; then
    echo macOS detected
    brew install fish

  elif [[ $(uname -o) == "Android" ]]; then
    echo Termux detected
    apt update
    apt install -y fish

  else
    echo assuming GNU Linux

    . /etc/os-release

    if [ "$ID" = "debian" ]; then
      if [ "$VERSION_ID" = "12" ]; then
        echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
        curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg >/dev/null
      elif [ "$VERSION_ID" = "11" ]; then
        echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_11/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
        curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_11/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg >/dev/null
      elif [ "$VERSION_ID" = "10" ]; then
        echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
        curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg >/dev/null
      fi
      sudo apt update
      sudo apt install -y fish
    elif [[ "$ID" == "ubuntu" || "$ID_LIKE" == "ubuntu debian" ]]; then
      if [ "$VERSION_ID" = "24.04" ]; then
        sudo apt update
        sudo apt install -y fish
      else
        sudo apt-add-repository ppa:fish-shell/release-3
        sudo apt update
        sudo apt install -y fish
      fi
    elif [ "$ID" = "fedora" ]; then
      dnf check-update
      sudo dnf install -y fish

    elif [ "$ID" = "opensuse" ]; then
      sudo zypper refresh
      sudo zypper install fish

    elif [ "$ID_LIKE" = "arch" ]; then
      sudo pacman -Sy --noconfirm fish

    fi
  fi

  sudo sed -i "s|^\($USER.*\)/bin/bash|\1/bin/fish|" /etc/passwd
  sudo sed -i "s|^\($USER.*\)/bin/zsh|\1/bin/fish|" /etc/passwd
fi

# setting PATH
PATH_TO_ADD="$HOME/.local/bin"
FISH_CONFIG_FILE="$HOME/.config/fish/config.fish"

is_path_set() {
  grep -q "$PATH_TO_ADD" "$FISH_CONFIG_FILE"
}

if ! is_path_set; then
    echo "set -a fish_user_paths $PATH_TO_ADD" >> "$FISH_CONFIG_FILE"
fi

if [[ $(uname -o) == "Darwin" ]]; then
  THE_SHELL='/opt/homebrew/bin/fish'
  if ! grep -q /opt/homebrew/bin $FISH_CONFIG_FILE; then
      echo "set -a fish_user_paths /opt/homebrew/bin" >> "$FISH_CONFIG_FILE"
  fi
  if ! grep -q /usr/local/bin $FISH_CONFIG_FILE; then
      echo "set -a fish_user_paths /usr/local/bin" >> "$FISH_CONFIG_FILE"
  fi
else
  THE_SHELL='/bin/fish'
fi

# installing plugins
$THE_SHELL <<'EOF'
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher install jethrokuan/z
EOF
