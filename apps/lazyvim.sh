#!/bin/bash

if ! command -v nvim &>/dev/null; then
  curl -sL https://raw.githubusercontent.com/0f27/0-brew/main/package-installer | bash -s neovim
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

mkdir -p ~/.config/lazyvim/lua/config
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

mkdir -p ~/.config/lazyvim/lua/plugins
cat <<'EOF' >~/.config/lazyvim/lua/plugins/theme.lua
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
      -- colorscheme = "tokyonight",
      -- colorscheme = "catppuccin",
    },
  },
  -- {
  --   "folke/tokyonight.nvim",
  --   opts = {
  --     transparent = true,
  --     styles = {
  --       sidebars = "transparent",
  --       floats = "transparent",
  --     },
  --   },
  -- },
}
EOF

mkdir -p ~/.config/lazyvim/lua/config
cat <<'EOF' >~/.config/lazyvim/lua/config/options.lua
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.relativenumber = false

-- Spellcheck off everywhere by default.
-- LazyVim's own autocmds force spell=true on filetypes like markdown/gitcommit/text,
-- so this alone isn't enough — see config/autocmds.lua for the enforcement.
vim.opt.spell = false
EOF

cat <<'EOF' >~/.config/lazyvim/lua/config/autocmds.lua
-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Force spellcheck off for every filetype, overriding LazyVim's defaults
-- that turn it on for markdown/gitcommit/text. Toggle manually with <leader>us
-- if you ever want it back for a single buffer.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("disable_spell_everywhere", { clear = true }),
  callback = function()
    vim.opt_local.spell = false
  end,
})
EOF

mkdir -p ~/.config/lazyvim/lua/plugins
cat <<'EOF' >~/.config/lazyvim/lua/plugins/lint.lua
return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      markdown = {}, -- disable linting for markdown only
    },
  },
}
EOF

cat <<'EOF' >~/.config/lazyvim/lua/plugins/markdown.lua
return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    bullet = { enabled = false },
    checkbox = { enabled = false },
  },
}
EOF
