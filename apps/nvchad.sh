#!/bin/bash

if ! command -v nvim &>/dev/null; then
  curl -sL https://raw.githubusercontent.com/XelorR/package-installer/main/package-installer | bash -s neovim
fi

rm -rf ~/.config/nvchad ~/.local/share/nvchad
mkdir -p ~/.config/nvchad ~/.local/bin

cat <<'EOF' >~/.local/bin/nvchad
#!/usr/bin/env bash

NVIM_APPNAME=nvchad nvim $@
EOF
chmod +x ~/.local/bin/nvchad
if [ ! -f ~/.config/nvim/init.lua ]; then
  ln -s ~/.config/nvchad ~/.config/nvim
fi

git clone https://github.com/NvChad/starter ~/.config/nvchad
rm -rf ~/.config/nvchad/.git

cat <<'EOF' >~/.config/nvchad/lua/mappings.lua
require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set
local del = vim.keymap.del

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- insert mode
map("t", "<Esc>", "<C-\\><C-n>", { silent = true })

-- files
map("n", "<leader>cd", "<cmd>cd %:p:h<cr>", { noremap = true, desc = "cd to this file" })
map("n", "<leader>qq", "<cmd>qa<cr>", { noremap = true, desc = "quit" })
map("n", "<leader>/", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })

-- buffers
map("n", "<leader>bb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { noremap = true, desc = "delete other buffers" })
EOF

cat <<'EOF' >~/.config/nvchad/lua/configs/lspconfig.lua
-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "pyright", "bashls", "marksman" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.tsserver.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
-- }
EOF

cat <<'EOF' >~/.config/nvchad/lua/configs/conform.lua
local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "prettier" },
		javascript = { "prettier" },
		html = { "prettier" },
		markdown = { "prettier" }
		json = { "jq" },
		python = { "black" },
		sh = { "beautysh" },
		bash = { "beautysh" },
		zsh = { "beautysh" },
	},

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
}

return options
EOF

mkdir -p ~/.config/nvchad/lua/plugins
cat <<'EOF' >~/.config/nvchad/lua/plugins/init.lua
return {
	{
		"stevearc/conform.nvim",
		-- event = "BufWritePre", -- uncomment for format on save
		opts = require("configs.conform"),
	},

	-- These are some examples, uncomment them if you want to see them work!
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"css",
				"html",
				"ini",
				"json",
				"lua",
				"markdown",
				"org",
				"python",
				"toml",
				"vim",
				"vimdoc",
				"yaml",
			},
		},
	},
}
EOF
