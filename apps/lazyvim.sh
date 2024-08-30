#!/bin/bash

if ! command -v nvim &>/dev/null; then
  python3 -c "$(curl -sL https://raw.githubusercontent.com/XelorR/package-installer/main/package-installer)" neovim
fi

rm -rf ~/.config/lazyvim ~/.local/share/lazyvim
mkdir -p ~/.config/lazyvim ~/.local/bin

cat <<'EOF' >~/.local/bin/lazyvim
#!/usr/bin/env bash

NVIM_APPNAME=lazyvim nvim $@
EOF

chmod +x ~/.local/bin/lazyvim
ln -s ~/.local/bin/lazyvim ~/.local/bin/lvim
if [ ! -f ~/.config/nvim/init.lua ]; then
  ln -s ~/.config/lazyvim ~/.config/nvim
fi

(
  NVIM_APPNAME=lazyvim

  git clone https://github.com/LazyVim/starter ~/.config/lazyvim
  rm -rf ~/.config/lazyvim/.git

  mkdir -p ~/.config/lazyvim/lua/plugins
  cat <<'EOF' >~/.config/lazyvim/lua/plugins/nvim-notify.lua
return {
    "rcarriga/nvim-notify",
    opts = {
        level = 5,
        render = "compact",
        stages = "static",
    },
}
EOF

  cat <<'EOF' >~/.config/lazyvim/lua/config/keymaps.lua
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local del = vim.keymap.del

-- Return to normal mode with Esc in terminal
map("t", "<Esc>", "<C-\\><C-n>", { silent = true })

-- Files and buffers
map("n", "<leader>fs", "<cmd>w<cr>", { noremap = true, desc = "Save buffer" })
map("n", "<leader>cd", "<cmd>cd %:p:h<cr>", { noremap = true, desc = "cd to this file" })
map("n", "<leader>bb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
EOF
)

cat <<'EOF' >~/.config/lazyvim/lua/plugins/core.lua
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
      -- colorscheme = "catppuccin",
    },
  },
}
EOF
