#!/usr/bin/env bash

if [[ $(uname -o) == "Darwin" ]]; then
  brew install --cask wezterm

elif [[ $(uname -o) == "Android" ]]; then
  echo there is no wezterm in Termux

else

  . /etc/os-release

  # wezterm itself

  if [[ "$ID" == "fedora" && "$VARIANT_ID" != "silverblue" ]]; then
    sudo dnf copr enable wezfurlong/wezterm-nightly
    sudo dnf install -y wezterm
  elif [ "$ID_LIKE" = "opensuse suse" ]; then
    zypper --non-interactive install wezterm
  elif [[ "$ID" == "debian" || "$ID_LIKE" == "debian" || "$ID_LIKE" == "ubuntu debian" ]]; then
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo apt update
    sudo apt install -y wezterm
  elif [ "$ID_LIKE" = "arch" ]; then
    sudo pacman -Sy --noconfirm wezterm
  fi

# config

mkdir -p ~/.config/wezterm
cat <<'EOF' >~/.config/wezterm/wezterm.lua
local wezterm = require("wezterm")
local config = {}

-- config.default_prog = { "fish" }


-- basic decorations and theme
config.color_scheme = "Vs Code Dark+ (Gogh)"
-- config.window_background_opacity = 0.90
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- config.hide_tab_bar_if_only_one_tab = true
-- config.use_fancy_tab_bar = false
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- font
config.font_dirs = { ".fonts", "Library/Fonts" }
config.font = wezterm.font_with_fallback{
  -- "Liga SFMono Nerd Font",
  -- "MesloLGS Nerd Font Mono",
}
config.font_size = 11.5

-- disabling confirmation on exit
config.window_close_confirmation = "NeverPrompt"

-- keybinding
config.keys = {
  -- Warp-like splits
  {
    key = 'd',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal {domain="CurrentPaneDomain"},
  },
  {
    key = 'e',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical {domain="CurrentPaneDomain"},
  },
  -- Konsole-like splits
  {
    key = '(',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal {domain="CurrentPaneDomain"},
  },
  {
    key = ')',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical {domain="CurrentPaneDomain"},
  },
}

return config
EOF

fi
