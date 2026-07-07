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
map("n", "<leader>bb", function()
  Snacks.picker.buffers()
end, { desc = "Find buffers" })
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

vim.opt.relativenumber = true

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

mkdir -p ~/.config/lazyvim/lua/plugins
cat <<'EOF' >~/.config/lazyvim/lua/plugins/obsidian.lua
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>mt", "<cmd>ObsidianToday<cr>", desc = "Obsidian: Today" },
    { "<leader>my", "<cmd>ObsidianYesterday<cr>", desc = "Obsidian: Yesterday" },
    { "<leader>mm", "<cmd>ObsidianTomorrow<cr>", desc = "Obsidian: Tomorrow" },
    { "<leader>mn", "<cmd>ObsidianNew<cr>", desc = "Obsidian: New note" },
    { "<leader>ms", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: Search" },
    { "<leader>mq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: Quick switch" },
    { "<leader>mb", "<cmd>ObsidianBacklinks<cr>", desc = "Obsidian: Backlinks" },
    { "<leader>ml", "<cmd>ObsidianLink<cr>", desc = "Obsidian: Link an inline visual selection", mode = "v" },
    { "<leader>mL", "<cmd>ObsidianLinkNew<cr>", desc = "Obsidian: Create a new note and link it", mode = "v" },
    { "<leader>mr", "<cmd>ObsidianRename<cr>", desc = "Obsidian: Rename (updates links)" },
    { "<leader>mo", "<cmd>ObsidianOpen<cr>", desc = "Obsidian: Open in Obsidian" },
  },
  opts = {
    workspaces = {
      {
        name = "vault",
        path = "~/Org/vault_markdown", -- change to your vault location
      },
    },
    ui = {
      enable = true,
      checkboxes = {},
      bullets = {},
    },
    picker = {
      name = "snacks.pick",
    },
    preferred_link_style = "markdown",
  },
}
EOF

# --- md-extract: local plugin for extracting a markdown header/selection
# into a new linked note. Pure Lua, no external deps, so it's embedded
# directly rather than pulled via lazy.nvim. Bound to <leader>mx, which
# doesn't collide with the obsidian.nvim keymaps above.

mkdir -p ~/.config/lazyvim/lua/md-extract
cat <<'EOF' >~/.config/lazyvim/lua/md-extract/util.lua
local M = {}

function M.timestamp()
  return os.date("%Y%m%d%H%M")
end

-- Strip a single leading heading/list/checkbox marker from a line.
function M.strip_leading_marker(line)
  local hashes, rest = line:match("^(#+)%s+(.*)$")
  if hashes then
    return rest
  end

  local marker, _box, rest2 = line:match("^%s*([%-%*%+])%s+%[([ xX])%]%s+(.*)$")
  if marker then
    return rest2
  end

  local marker2, rest3 = line:match("^%s*([%-%*%+])%s+(.*)$")
  if marker2 then
    return rest3
  end

  local rest4 = line:match("^%s*%d+%.%s+(.*)$")
  if rest4 then
    return rest4
  end

  return line
end

-- Unwrap markdown/wiki links found anywhere inside `text`, keeping only their
-- display text. Used to avoid "link inside a link" when building titles/slugs.
function M.unwrap_links(text)
  local out = text
  -- [[target|alias]] -> alias
  out = out:gsub("%[%[([^%]|]-)|([^%]]-)%]%]", "%2")
  -- [[target]] -> target
  out = out:gsub("%[%[([^%]]-)%]%]", "%1")
  -- [text](url) -> text
  out = out:gsub("%[([^%]]-)%]%(([^%)]-)%)", "%1")
  return out
end

local function collapse_ws(s)
  s = s:gsub("%s+", " ")
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  return s
end

M.collapse_ws = collapse_ws

-- Clean display title from a raw source line: strip one leading marker,
-- unwrap any links, collapse whitespace.
function M.clean_title(raw_line)
  local stripped = M.strip_leading_marker(raw_line)
  local unwrapped = M.unwrap_links(stripped)
  return collapse_ws(unwrapped)
end

-- Filesystem-safe slug: illegal chars stripped, whitespace -> "_".
function M.sanitize_filename(title)
  local s = title
  s = s:gsub('[/\\:%*%?"<>|]', "")
  s = collapse_ws(s)
  s = s:gsub("%s", "_")
  s = s:gsub("^_+", ""):gsub("_+$", "")
  if s == "" then
    s = "untitled"
  end
  return s
end

local function indent_kind(lines)
  local has_tab, has_space = false, false
  for _, l in ipairs(lines) do
    local lead = l:match("^(%s*)")
    if lead:find("\t") then
      has_tab = true
    end
    if lead:find(" ") then
      has_space = true
    end
  end
  if has_tab and has_space then
    return "mixed"
  elseif has_tab then
    return "tab"
  else
    return "space"
  end
end

-- Dedent a block of lines to the minimal common indentation.
-- If leading whitespace mixes tabs and spaces, tabs are expanded to
-- `tabstop` spaces first. Pure-tab indentation is preserved as tabs.
function M.dedent(lines, tabstop)
  tabstop = tabstop or 4
  local kind = indent_kind(lines)
  local work = {}
  if kind == "mixed" then
    for i, l in ipairs(lines) do
      local lead, rest = l:match("^(%s*)(.*)$")
      lead = lead:gsub("\t", string.rep(" ", tabstop))
      work[i] = lead .. rest
    end
  else
    for i, l in ipairs(lines) do
      work[i] = l
    end
  end

  local min_indent = nil
  for _, l in ipairs(work) do
    if l:match("%S") then
      local n = #(l:match("^(%s*)"))
      if min_indent == nil or n < min_indent then
        min_indent = n
      end
    end
  end
  min_indent = min_indent or 0

  local out = {}
  for i, l in ipairs(work) do
    if l:match("%S") then
      out[i] = l:sub(min_indent + 1)
    else
      out[i] = ""
    end
  end
  return out
end

-- Trim leading/trailing blank lines from a list of lines.
function M.trim_blank_edges(lines)
  local first, last = 1, #lines
  while first <= last and lines[first]:match("^%s*$") do
    first = first + 1
  end
  while last >= first and lines[last]:match("^%s*$") do
    last = last - 1
  end
  local out = {}
  for i = first, last do
    table.insert(out, lines[i])
  end
  return out
end

return M
EOF

cat <<'EOF' >~/.config/lazyvim/lua/md-extract/markdown.lua
local M = {}

-- Find the markdown header that "owns" `cursor_line` (1-indexed), by walking
-- upward from the cursor to the nearest header line, then finding the end of
-- its scope (next header of the same or higher level, or end of buffer).
-- Returns header_idx, scope_end_idx, level, or nil if no header is found.
function M.find_header_scope(lines, cursor_line)
  local header_idx, level = nil, nil
  for i = cursor_line, 1, -1 do
    local hashes = lines[i]:match("^(#+)%s")
    if hashes then
      header_idx = i
      level = #hashes
      break
    end
  end
  if not header_idx then
    return nil
  end

  local scope_end = #lines
  for i = header_idx + 1, #lines do
    local hashes = lines[i]:match("^(#+)%s")
    if hashes and #hashes <= level then
      scope_end = i - 1
      break
    end
  end

  return header_idx, scope_end, level
end

-- Shift the level of every markdown header found in `lines` by `delta`,
-- clamped so levels never drop below 1 (#).
function M.normalize_header_levels(lines, delta)
  local out = {}
  for i, l in ipairs(lines) do
    local hashes, rest = l:match("^(#+)(%s.*)$")
    if hashes then
      local new_level = math.max(1, #hashes + delta)
      out[i] = string.rep("#", new_level) .. rest
    else
      out[i] = l
    end
  end
  return out
end

-- Find the minimum header level among `lines`, or nil if none contain a header.
function M.min_header_level(lines)
  local min_level = nil
  for _, l in ipairs(lines) do
    local hashes = l:match("^(#+)%s")
    if hashes and (min_level == nil or #hashes < min_level) then
      min_level = #hashes
    end
  end
  return min_level
end

-- Read the current visual selection bounds using the '< '> marks.
-- Returns srow, scol, erow, ecol (1-indexed, byte columns) and the visual
-- mode ('v' charwise, 'V' linewise, or CTRL-V blockwise), or nil if there is
-- no selection.
function M.get_visual_selection()
  local mode = vim.fn.visualmode()
  local sp = vim.fn.getpos("'<")
  local ep = vim.fn.getpos("'>")
  local srow, scol = sp[2], sp[3]
  local erow, ecol = ep[2], ep[3]

  if srow == 0 or erow == 0 then
    return nil
  end
  if srow > erow or (srow == erow and scol > ecol) then
    srow, scol, erow, ecol = erow, ecol, srow, scol
  end

  return srow, scol, erow, ecol, mode
end

return M
EOF

cat <<'EOF' >~/.config/lazyvim/lua/md-extract/extract.lua
local util = require("md-extract.util")
local mdparse = require("md-extract.markdown")

local M = {}

local function write_file(path, lines)
  local f, err = io.open(path, "w")
  if not f then
    error("Cannot open file for writing: " .. tostring(err))
  end
  f:write(table.concat(lines, "\n"))
  f:write("\n")
  f:close()
end

-- Append mode: used when bang-mode targets a note that already exists.
local function append_file(path, lines)
  local f, err = io.open(path, "a")
  if not f then
    error("Cannot open file for appending: " .. tostring(err))
  end
  f:write(table.concat(lines, "\n"))
  f:write("\n")
  f:close()
end

local function file_exists(path)
  return vim.fn.filereadable(path) == 1
end

local function source_file_name(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then
    error("Buffer is not associated with a file yet -- save it first")
  end
  return vim.fn.fnamemodify(path, ":t")
end

local function target_dir(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  return vim.fn.fnamemodify(path, ":p:h")
end

local function backlink_line(bufnr)
  local name = source_file_name(bufnr)
  -- "daily_notes.md" -> "daily notes" for a readable link title
  local title = vim.fn.fnamemodify(name, ":r"):gsub("_", " ")
  return string.format("- [%s](./%s)", title, name)
end

-- Decide the target filename/path for this extraction.
-- Normal mode: always a fresh timestamped file.
-- Bang mode: no timestamp; if a note with that slug already exists, the
-- caller is expected to append to it instead of overwriting it.
local function resolve_target(bufnr, title, bang)
  local dir = target_dir(bufnr)
  if bang then
    local filename = util.sanitize_filename(title) .. ".md"
    local filepath = dir .. "/" .. filename
    return filename, filepath, file_exists(filepath)
  end
  local filename = util.timestamp() .. "_" .. util.sanitize_filename(title) .. ".md"
  local filepath = dir .. "/" .. filename
  return filename, filepath, false
end

--- Extract the header under the cursor (or the header it belongs to).
-- bang == true: no timestamp prefix; if a note with the same name already
-- exists, append this extraction to the bottom of it instead of creating a
-- new file, stamping the added heading with today's date.
function M.extract_header(bufnr, bang)
  bufnr = bufnr or 0
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]

  local header_idx, scope_end, level = mdparse.find_header_scope(lines, cursor_line)
  if not header_idx then
    error("No markdown header found above the cursor")
  end

  local header_raw = lines[header_idx]
  local header_text = header_raw:match("^#+%s+(.*)$")
  local title = util.clean_title(header_raw)
  if title == "" then
    error("Extracted title is empty")
  end

  local body_raw = {}
  for i = header_idx + 1, scope_end do
    table.insert(body_raw, lines[i])
  end
  body_raw = util.trim_blank_edges(body_raw)
  local body = mdparse.normalize_header_levels(body_raw, 1 - level)

  local filename, filepath, merge = resolve_target(bufnr, title, bang)

  if merge then
    local heading = "# " .. header_text .. " (extracted " .. os.date("%Y-%m-%d %H:%M") .. ")"
    local block = { "", "---", "", backlink_line(bufnr), "", heading, "" }
    vim.list_extend(block, body)
    append_file(filepath, block)
  else
    local new_lines = { backlink_line(bufnr), "", "# " .. header_text, "" }
    vim.list_extend(new_lines, body)
    write_file(filepath, new_lines)
  end

  local replacement = header_raw:gsub("^(#+%s+).*$", "%1[" .. title .. "](./" .. filename .. ")")

  -- Don't swallow a blank separator line that precedes the next header (or
  -- EOF): scope_end includes it so the new note's body gets trimmed
  -- correctly, but removing it from the source buffer would glue the
  -- replacement line directly to the following header.
  local buffer_cut_end = scope_end
  while buffer_cut_end > header_idx and lines[buffer_cut_end]:match("^%s*$") do
    buffer_cut_end = buffer_cut_end - 1
  end

  local new_buf_lines = {}
  for i = 1, header_idx - 1 do
    table.insert(new_buf_lines, lines[i])
  end
  table.insert(new_buf_lines, replacement)
  for i = buffer_cut_end + 1, #lines do
    table.insert(new_buf_lines, lines[i])
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_buf_lines)
  vim.notify("MdExtract: " .. (merge and "appended to " or "created ") .. filename)
end

--- Extract the current visual selection.
-- bang == true: same no-timestamp / merge-if-exists behavior as extract_header.
function M.extract_selection(bufnr, bang)
  bufnr = bufnr or 0
  local srow, scol, erow, ecol, mode = mdparse.get_visual_selection()
  if not srow then
    error("No visual selection found")
  end
  if mode == "\22" then
    error("Block-wise visual selection is not supported")
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  if mode == "V" then
    scol = 1
    ecol = #lines[erow]
  else
    ecol = math.min(ecol, #lines[erow])
  end

  local first_line = lines[srow]
  local last_line = lines[erow]

  local first_seg
  if srow == erow then
    first_seg = first_line:sub(scol, ecol)
  else
    first_seg = first_line:sub(scol, #first_line)
  end

  local title = util.clean_title(first_seg)
  if title == "" then
    error("Extracted title is empty")
  end

  local body_raw = {}
  if srow ~= erow then
    for i = srow + 1, erow - 1 do
      table.insert(body_raw, lines[i])
    end
    table.insert(body_raw, last_line:sub(1, ecol))
  end
  body_raw = util.trim_blank_edges(body_raw)

  -- If the selected body contains headers, normalize them so the shallowest
  -- one becomes level 2 (the new note's title occupies level 1), preserving
  -- relative nesting -- same idea as in extract_header.
  local min_lvl = mdparse.min_header_level(body_raw)
  if min_lvl then
    body_raw = mdparse.normalize_header_levels(body_raw, 2 - min_lvl)
  end

  local body = util.dedent(body_raw)
  local title_line = util.collapse_ws(first_seg)

  local filename, filepath, merge = resolve_target(bufnr, title, bang)

  if merge then
    local heading = "# " .. title_line .. " (extracted " .. os.date("%Y-%m-%d %H:%M") .. ")"
    local block = { "", "---", "", backlink_line(bufnr), "", heading, "" }
    vim.list_extend(block, body)
    append_file(filepath, block)
  else
    local new_lines = { backlink_line(bufnr), "", "# " .. title_line, "" }
    vim.list_extend(new_lines, body)
    write_file(filepath, new_lines)
  end

  local prefix = first_line:sub(1, scol - 1)
  local suffix = last_line:sub(ecol + 1, #last_line)
  local link = "[" .. title .. "](./" .. filename .. ")"
  local replacement_line = prefix .. link .. suffix

  local new_buf_lines = {}
  for i = 1, srow - 1 do
    table.insert(new_buf_lines, lines[i])
  end
  table.insert(new_buf_lines, replacement_line)
  for i = erow + 1, #lines do
    table.insert(new_buf_lines, lines[i])
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_buf_lines)
  vim.notify("MdExtract: " .. (merge and "appended to " or "created ") .. filename)
end

--- Entry point used by the :MdExtract command.
-- Bang (:MdExtract!) drops the timestamp prefix and merges into an
-- existing same-named note if one is found in the target directory.
function M.run(opts)
  local bufnr = 0
  local ok, err = pcall(function()
    if opts and opts.range and opts.range == 2 then
      M.extract_selection(bufnr, opts.bang)
    else
      M.extract_header(bufnr, opts.bang)
    end
  end)
  if not ok then
    vim.notify("MdExtract: " .. tostring(err), vim.log.levels.ERROR)
  end
end

return M
EOF

cat <<'EOF' >~/.config/lazyvim/lua/md-extract/init.lua
local M = {}

-- Attach the :MdExtract command and default keymaps to a specific buffer.
-- Meant to be called from ftplugin/markdown.lua, so it only ever applies to
-- markdown buffers.
function M.attach(bufnr)
  bufnr = bufnr or 0

  vim.api.nvim_buf_create_user_command(bufnr, "MdExtract", function(opts)
    require("md-extract.extract").run(opts)
  end, {
    range = true,
    bang = true,
    desc = "Extract markdown header/selection into a new linked note "
      .. "(! = no timestamp; merge into an existing same-named note if found)",
  })

  vim.keymap.set("n", "<leader>mx", "<cmd>MdExtract<CR>", {
    buffer = bufnr,
    desc = "Extract header into new note",
  })
  vim.keymap.set("v", "<leader>mx", ":MdExtract<CR>", {
    buffer = bufnr,
    desc = "Extract selection into new note",
  })
  vim.keymap.set("n", "<leader>mX", "<cmd>MdExtract!<CR>", {
    buffer = bufnr,
    desc = "Extract header, no timestamp, merge into existing note if found",
  })
  vim.keymap.set("v", "<leader>mX", ":MdExtract!<CR>", {
    buffer = bufnr,
    desc = "Extract selection, no timestamp, merge into existing note if found",
  })
end

return M
EOF

mkdir -p ~/.config/lazyvim/ftplugin
cat <<'EOF' >~/.config/lazyvim/ftplugin/markdown.lua
if vim.b.md_extract_loaded then
  return
end
vim.b.md_extract_loaded = true

require("md-extract").attach(0)
EOF
