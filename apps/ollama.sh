#!/usr/bin/env sh

if [[ $(uname -o) == "Darwin" ]]; then
  brew install --cask ollama

elif [[ $(uname -o) == "Android" ]]; then
  echo Ollama is not supported in Termux

else
  . /etc/os-release

  if command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm ollama
    sudo systemctl enable --now ollama

  elif [[ "$(uname -m)" == "x86_64" ]]; then
    # Define Ollama installation path
    mkdir -p $HOME/.local/bin
    OLLAMA_PATH="$HOME/.local/bin/ollama"

    # Download and install Ollama
    wget https://ollama.com/download/ollama-linux-amd64 -O $OLLAMA_PATH && chmod +x $OLLAMA_PATH

    # Create systemd service file for Ollama
    mkdir -p $HOME/.config/systemd/user
    cat <<EOF >$HOME/.config/systemd/user/ollama.service
[Unit]
Description=Ollama Service
After=network-online.target
[Service]
ExecStart=$OLLAMA_PATH serve
Restart=always
RestartSec=3
[Install]
WantedBy=default.target
EOF

    # Reload systemd, enable and start the service
    systemctl --user daemon-reload
    systemctl --user enable --now ollama

  elif [[ "$(uname -m)" == "aarch64" ]]; then
    echo Ollama has no installation candidates for aarch64 on GNU Linux
  fi
fi
