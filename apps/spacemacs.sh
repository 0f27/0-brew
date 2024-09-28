#!/usr/bin/env bash

if ! command -v emacs &>/dev/null; then
  if [[ $(uname -o) == "Darwin" ]]; then
    brew install emacs

  elif [[ $(uname -o) == "Android" ]]; then
    apt update
    apt install -y emacs

  else

    . /etc/os-release

    if command -v pacman &>/dev/null; then
      sudo pacman -Sy --noconfirm emacs git ripgrep fd

    elif command -v rpm-ostree &>/dev/null; then
      sudo rpm-ostree install --apply-live -y emacs git ripgrep fd-find

    elif command -v zypper &>/dev/null; then
      sudo zypper refresh
      sudo zypper --non-interactive --no-confirm install emacs git ripgrep fd-find

    elif command -v dnf &>/dev/null; then
      dnf check-update
      sudo dnf install -y emacs git ripgrep fd-find

    elif command -v snap &>/dev/null; then
      sudo snap instal emacs --classic
      sudo snap instal ripgrep --classic

    elif command -v apt &>/dev/null; then
      sudo apt update
      sudo apt install -y emacs ripgrep git fd-find

    fi
  fi
fi

EMACS_VERSION="$(emacs --version | head -n 1 | cut -d' ' -f 3)"
EMACS_INIT_DIRECTORY="$HOME/.opt/spacemacs"

if [ ! -d $EMACS_INIT_DIRECTORY ]; then
  mkdir -p $EMACS_INIT_DIRECTORY
  git clone --depth 1 https://github.com/syl20bnr/spacemacs $EMACS_INIT_DIRECTORY/.emacs.d
fi

if [ ! -d $HOME/.config/emacs ] && [ ! -f $HOME/.emacs ] && [ ! -d $HOME/.emacs ] && [ ! -d $HOME/.emacs.d ]; then
  mkdir -p $HOME/.config
  ln -s $EMACS_INIT_DIRECTORY/.emacs.d $HOME/.emacs.d
fi

mkdir -p ~/.local/bin
cat <<'EOF' >~/.local/bin/spacemacs
#!/usr/bin/env bash

emacs --init-directory=$HOME/.opt/spacemacs/.emacs.d $@
EOF
chmod +x ~/.local/bin/spacemacs
