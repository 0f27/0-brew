#!/usr/bin/env bash

if ! command -v emacs &>/dev/null; then
  if command -v brew &>/dev/null; then
    brew install emacs

  elif [[ $(uname -o) == "Android" ]]; then
    apt update
    apt install -y emacs

  else

    . /etc/os-release

    if command -v pacman &>/dev/null; then
      sudo pacman -Sy --noconfirm emacs

    elif command -v rpm-ostree &>/dev/null; then
      sudo rpm-ostree install --apply-live -y emacs

    elif command -v zypper &>/dev/null; then
      sudo zypper refresh
      sudo zypper --non-interactive --no-confirm install emacs

    elif command -v dnf &>/dev/null; then
      dnf check-update
      sudo dnf install -y emacs

    elif command -v apt &>/dev/null; then
      sudo apt update
      sudo apt install -y emacs

    fi
  fi
fi

EMACS_VERSION="$(emacs --version | head -n 1 | cut -d' ' -f 3)"

if [ -d $HOME/.config/emacs ] && [ -f $HOME/.emacs ] && [ -d $HOME/.emacs ] && [ -d $HOME/.emacs.d ]; then
  EMACS_INIT_DIRECTORY="$HOME/.opt/doom"

  mkdir -p ~/.local/bin
  cat <<'EOF' >~/.local/bin/doom
#!/usr/bin/env bash

emacs --init-directory=$HOME/.opt/doom/.config/emacs $@
EOF
  chmod +x ~/.local/bin/doom

else
  EMACS_INIT_DIRECTORY=$HOME
fi

if [ ! -d $EMACS_INIT_DIRECTORY ]; then
  mkdir -p $EMACS_INIT_DIRECTORY/.config
  # rm -rf $HOME/.emacs $HOME/.emacs.d $HOME/.config/emacs
  git clone --depth 1 https://github.com/doomemacs/doomemacs $EMACS_INIT_DIRECTORY/.config/emacs
  $EMACS_INIT_DIRECTORY/.config/emacs/bin/doom install --env -!
fi
