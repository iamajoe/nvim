----------------------------------------------------
-- CHECKS

-- nvim 0.12 is required for `vim.pack`.
if vim.fn.has "nvim-0.12" == 0 then
  error "[ERROR] Requires nvim 0.12"
end

-- make sure we have the undo dir
local undodir = os.getenv("HOME") .. "/.vim/undodir"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end


-- disable providers that we don't use
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0

----------------------------------------------------
-- GENERAL SETTINGS

vim.opt.mouse                 = "a"  -- Enable mouse support
vim.opt.list                  = true -- use special characters to represent things like tabs or trailing spaces
vim.opt.listchars             = {
  tab = "▏ ",
  trail = "·",
  extends = "»",
  precedes = "«",
}
vim.opt.showmatch             = false -- show matching bracket
vim.opt.showmode              = false -- dont show mode on cmdline

-- Performance improvements
vim.opt.redrawtime            = 10000
vim.opt.maxmempattern         = 20000

-- Appearance / UI
vim.opt.number                = true                                        -- show absolute line numbers
vim.opt.relativenumber        = true                                        -- show relative line numbers (except current)
vim.opt.cursorline            = true                                        -- highlight the current line
vim.opt.colorcolumn           = "90"                                        -- highlight column 90
vim.opt.signcolumn            = "yes"                                       -- always show the sign column
vim.opt.showtabline           = 1                                           -- show tabline only if multiple tabs
vim.opt.winborder             = "rounded"                                   -- use rounded window borders in popups
vim.opt.termguicolors         = true                                        -- enable 24-bit colors
vim.o.statuscolumn            = "%=%{v:relnum == 0 ? v:lnum : v:relnum} %s" -- templates gutter
vim.opt.laststatus            = 2                                           -- allows show status line
vim.opt.statusline            = "[%{mode()}] %f » %F %m %= %y [%c:%l-%L]"   -- template status line

-- Indentation / Tabs
vim.opt.expandtab             = true -- convert tabs to spaces
vim.opt.tabstop               = 2    -- how many spaces a literal <Tab> shows as
vim.opt.shiftwidth            = 2    -- spaces for each step of (auto)indent
vim.opt.softtabstop           = 2    -- spaces a <Tab> counts for while editing
vim.opt.smartindent           = true -- smart auto-indenting on new lines

-- Search
vim.opt.ignorecase            = true  -- ignore case when searching
vim.opt.hlsearch              = false -- don't highlight search matches after Enter
vim.opt.incsearch             = true  -- show search matches as you type

-- Scrolling / navigation
vim.opt.scrolloff             = 8     -- keep 8 lines visible when scrolling
vim.opt.sidescrolloff         = 8     -- Keep 8 columns left/right of cursor
vim.opt.wrap                  = false -- don't wrap long lines

-- Files / persistence
vim.opt.swapfile              = false                 -- don't create swap files
vim.opt.undodir               = undodir               -- dir for undo history
vim.opt.undofile              = true                  -- keep undo history across sessions
vim.opt.fileencoding          = "utf-8"               -- file encoding to use when writing
vim.opt.isfname:append("@-@")                         -- treat "@-@" as part of filenames
vim.opt.switchbuf = { "useopen", "usetab", "newtab" } -- eg.: quickfix open on new tab
vim.opt.autoread = true                               -- auto read files if changed outside

-- Ripgrep
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.g.have_nerd_font = true
vim.g.mapleader = " "

vim.diagnostic.config({
  signs = {
    linehl = {
      -- [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    },
  },
  underline = true,
  update_in_insert = false,
  -- virtual_lines = { current_line = true, },
  virtual_lines = false,
  virtual_text = { current_line = true, },
})

----------------------------------------------------
-- HELPERS

local function find_git_root()
  -- Start from the current buffer’s directory
  local bufpath = vim.api.nvim_buf_get_name(0)
  local dir = vim.fs.dirname(bufpath)
  local root = vim.fs.find(".git", { path = dir, upward = true })[1]
  if root then
    return vim.fs.dirname(root) -- parent of ".git"
  else
    return vim.loop.cwd()       -- fallback to current working dir
  end
end

local function toggle_qf_or_loclist()
  local buftype = vim.bo.buftype

  -- Case 1: already in quickfix or loclist → go back to previous buffer
  if buftype == "quickfix" then
    vim.cmd("wincmd p") -- jump to previous window
    return
  end

  -- Case 2: in a normal buffer → prefer loclist, else quickfix
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.loclist == 1 then
      vim.cmd("lopen")
      return
    end
  end

  if vim.fn.getqflist({ winid = 1 }).winid ~= 0 then
    vim.cmd("copen")
    return
  end

  vim.notify("No location list or quickfix available", vim.log.levels.INFO)
end

local function git_branch()
  -- gitsigns path (fast, async-cached)
  local head = vim.b.gitsigns_head or (vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head)
  if head and #head > 0 then return head end
  -- fallback: cheap shell call (silenced if not a repo)
  local ok, res = pcall(function()
    return vim.fn.systemlist({ "git", "-C", vim.fn.expand("%:p:h"), "rev-parse", "--abbrev-ref", "HEAD" })[1]
  end)
  if ok and res and #res > 0 and not res:match("fatal:") then return res end
  return ""
end

-- Word count for text files
local function word_count()
  local ft = vim.bo.filetype
  if ft == "markdown" or ft == "text" or ft == "tex" then
    local words = vim.fn.wordcount().words
    return "  " .. words .. " words "
  end
  return ""
end

-- File size
local function file_size()
  local size = vim.fn.getfsize(vim.fn.expand('%'))
  if size < 0 then return "" end
  if size < 1024 then
    return size .. "B "
  elseif size < 1024 * 1024 then
    return string.format("%.1fK", size / 1024)
  else
    return string.format("%.1fM", size / 1024 / 1024)
  end
end

----------------------------------------------------
-- PLUGINS

vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },                        -- file explorer
  { src = "https://github.com/echasnovski/mini.pick" },                    -- pick files
  { src = "https://github.com/numToStr/Comment.nvim" },                    -- toggle comment
  { src = "https://github.com/Saghen/blink.cmp",                version = "v1.6.0" }, -- autocompletion
  { src = "https://github.com/catppuccin/nvim" },                          -- theme
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  -- NOTE: decided to use manual config per language that way i have more control
  --       i copy the files from lspconfig whenever i need them and it is one less
  --       dependency. it is not as simple as using the dependency though because
  --       i have updated the configuration files with tweaks. check that first
  -- { src = "https://github.com/neovim/nvim-lspconfig" },
})

require "mini.pick".setup({
  window = {
    config = function()
      local height = math.floor(0.4 * vim.o.lines)
      local width = math.floor(0.5 * vim.o.columns)

      return {
        anchor = 'NW',
        height = height,
        width = width,
        row = math.floor(0.5 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
      }
    end
  },
})

require "nvim-treesitter.configs".setup({
  ensure_installed = { 
    "typescript", 
    "javascript", 
    "html", 
    "css", 
    "go", 
    "rust", 
    "toml", 
    "json", 
    "lua",
  },

  -- optional: download any missing parser automatically when you open a file
  auto_install = true,

  highlight = {
    enable = true,
    -- stay lean: don’t run Vim’s regex highlighter alongside TS
    additional_vim_regex_highlighting = false,
    -- optional: turn TS highlight off for very large files
    disable = function(lang, buf)
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      return ok and stats and stats.size > 500 * 1024 -- >500KB
    end,
  },
})

require "oil".setup({
  default_file_explorer = true,
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  columns = { "icon" },
  keymaps = {
    ["<C-s>"] = false,
    ["<C-h>"] = false,
    ["<C-t>"] = false,
    ["<C-p>"] = false,
    ["<M-p>"] = "actions.preview",
    -- ["<M-h>"] = "actions.select_split",
  },
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, _)
      return name == ".." or name == ".git" or name == "node_modules" -- or name == "vendor"
    end,
  },
})

require("Comment").setup()

require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<C-Space>"] = { function(cmp) cmp.show() end },
    ["<C-d>"] = { "show", "show_documentation", "hide_documentation" },
  },
  signature = {
    enabled = true,
    window = {
      border = "single",
      max_width = math.floor(vim.o.columns * 0.8),
      max_height = math.floor(vim.o.lines * 0.8),
    },
    trigger = { show_on_trigger_character = true, show_on_insert = true, },
  },
  completion = {
    accept = { auto_brackets = { enabled = false, }, },
    trigger = { show_on_accept_on_trigger_character = false, },
    list = { selection = { preselect = false, auto_insert = false, }, },
    keyword = { range = "full", },
    ghost_text = {
      enabled = false,
      show_with_selection = true,
      show_without_selection = false,
      show_with_menu = true,
    },
    menu = {
      auto_show = true,
      border = "single",
      draw = {
        gap = 1,
        padding = 1,
        treesitter = { "lsp" },
        columns = {
          { "kind_icon" },
          { "label",    "label_description", gap = 1 },
        },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 100,
      treesitter_highlighting = true,
      window = {
        border = "single",
        max_width = math.floor(vim.o.columns * 0.8),
        max_height = math.floor(vim.o.lines * 0.8),
      },
    },
  },
  -- sources = { default = { "lsp", "path", "buffer", "snippets" } },
})

----------------------------------------------------
-- LSP

vim.lsp.enable({ "lua_ls", "rust_analyzer", "ts_ls", "gopls", "eslint" })
-- NOTE: if you don't want to use custom files but lspconfig here is an example...
-- vim.lsp.config("lua_ls", { settings = { Lua = { ... } } })

----------------------------------------------------
-- THEME

require "catppuccin".setup({ flavour = "mocha", transparent_background = true })
vim.cmd("colorscheme catppuccin")
vim.cmd("hi statusline guibg=NONE")

-- Catppuccin Mocha palette
local C = {
  base = "#1e1e2e",
  mantle = "#181825",
  surface0 = "#313244",
  surface1 = "#45475a",
  text = "#cdd6f4",
  subtext0 = "#a6adc8",
  red = "#f38ba8",
  peach = "#fab387",
  yellow = "#f9e2af",
  green = "#a6e3a1",
  teal = "#94e2d5",
  blue = "#89b4fa",
  mauve = "#cba6f7"
}

----------------------------------------------------
-- STATUS LINE

-- 1) Highlight groups that fit Catppuccin nicely
vim.api.nvim_set_hl(0, "SLModeNormal", { bg = C.green, fg = C.mantle, bold = true })
vim.api.nvim_set_hl(0, "SLModeInsert", { bg = C.blue, fg = C.mantle, bold = true })
vim.api.nvim_set_hl(0, "SLModeVisual", { bg = C.mauve, fg = C.mantle, bold = true })
vim.api.nvim_set_hl(0, "SLModeReplace", { bg = C.red, fg = C.mantle, bold = true })
vim.api.nvim_set_hl(0, "SLModeCommand", { bg = C.teal, fg = C.mantle, bold = true })
vim.api.nvim_set_hl(0, "SLModeTerminal", { bg = C.peach, fg = C.mantle, bold = true })

vim.api.nvim_set_hl(0, "SLInfo", { fg = C.text, bold = true })
vim.api.nvim_set_hl(0, "SLDim", { fg = C.subtext0 })
vim.api.nvim_set_hl(0, "SLBlock", { bg = C.surface0, fg = C.text })
vim.api.nvim_set_hl(0, "SLModified", { fg = C.red, bold = true })
vim.api.nvim_set_hl(0, "SLGit", { fg = C.mauve, bold = false })
vim.api.nvim_set_hl(0, "SLErr", { fg = C.red, bold = true })
vim.api.nvim_set_hl(0, "SLWarn", { fg = C.peach, bold = true })
vim.api.nvim_set_hl(0, "SLHint", { fg = C.teal, bold = true })
vim.api.nvim_set_hl(0, "SLInfoDiag", { fg = C.blue, bold = true })

-- 2) Status methods
_G.file_size = file_size
_G.mode_extended = function()
  local m = vim.api.nvim_get_mode().mode
  local label = ({
    n = "NORMAL", no = "OP-PENDING", nov = "OP-PENDING", ["noV"] = "OP-PENDING",
    niI = "NORMAL", niR = "NORMAL", niV = "NORMAL",
    v = "VISUAL", V = "V-LINE", ["\22"] = "V-BLOCK", -- <C-v>
    s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK", -- <C-s>
    i = "INSERT", ic = "INSERT", ix = "INSERT",
    R = "REPLACE", Rc = "REPLACE", Rv = "REPLACE",
    c = "COMMAND", cv = "EX", ce = "EX",
    r = "PROMPT", rm = "MORE", ["r?"] = "CONFIRM",
    t = "TERMINAL",
  })[m] or m

  local group = ({
    n = "SLModeNormal", niI = "SLModeNormal", niR = "SLModeNormal", niV = "SLModeNormal",
    v = "SLModeVisual", V = "SLModeVisual", ["\22"] = "SLModeVisual",
    s = "SLModeVisual", S = "SLModeVisual", ["\19"] = "SLModeVisual",
    i = "SLModeInsert", ic = "SLModeInsert", ix = "SLModeInsert",
    R = "SLModeReplace", Rc = "SLModeReplace", Rv = "SLModeReplace",
    c = "SLModeCommand", cv = "SLModeCommand", ce = "SLModeCommand",
    t = "SLModeTerminal",
  })[m] or "SLModeNormal"

  return string.format("%%#%s# %s %%*", group, label)
end
_G.status_git_branch = function()
  local br = git_branch()
  if br == "" then return "" end
  return string.format("(%s)", br) -- "" is the branch glyph; swap if your font lacks it
end
_G.status_diags = function()
  local bufnr = 0
  local function count(sev) return #vim.diagnostic.get(bufnr, { severity = sev }) end
  local e = count(vim.diagnostic.severity.ERROR)
  local w = count(vim.diagnostic.severity.WARN)
  local h = count(vim.diagnostic.severity.HINT)
  local i = count(vim.diagnostic.severity.INFO)

  local parts = {}
  if e > 0 then table.insert(parts, string.format("[%%#SLErr#Errors: %d%%*]", e)) end
  if w > 0 then table.insert(parts, string.format("[%%#SLWarn#Warnings: %d%%*]", w)) end
  if i > 0 then table.insert(parts, string.format("[%%#SLInfoDiag#Info: %d%%*]", i)) end
  if h > 0 then table.insert(parts, string.format("[%%#SLHint#Hints: %d%%*]", h)) end
  return table.concat(parts, " ")
end

-- 5) finally set the status line
vim.opt.laststatus = 3 -- or 3 for a single global bar
vim.opt.statusline = table.concat({
  "%{%v:lua.mode_extended()%} ",
  "%#SLModified#%m%*",                       -- '+' when modified
  " %#SLInfo#%f%* ",                         -- filename
  "» %F ",                                   -- full path (bold)
  "%=",                                      -- right align after this
  "%#SLGit#%{v:lua.status_git_branch()}%* ", -- git branch (if any)
  "%{%v:lua.status_diags()%} ",              -- diagnostics (only shows existing severities)
  "%#SLDim#%y%* ",                           -- filetype, dimmed
  "%#SLDim#%{v:lua.file_size()}%* ",         -- file dimension
  "[%c:%l-%#SLDim#%L%*]",                    -- column: line-total block
})

----------------------------------------------------
-- COMMENT HIGHLIGHTS

-- TODO(joe): Wow!
-- NOTE(joe): Look at that!
-- IMPORTANT(joe): Awsome Highlighting!
-- STUDY(joe): Im so good at neovim config!
vim.api.nvim_set_hl(0, "Todo", { underline = false, fg = C.red })
vim.api.nvim_set_hl(0, "Note", { underline = false, fg = C.green })
vim.api.nvim_set_hl(0, "Study", { underline = false, fg = C.blue })
vim.api.nvim_set_hl(0, "Important", { underline = false, fg = C.mauve })

local highlightAutoCmds = vim.api.nvim_create_augroup('highlightAutoCmds', { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*",
  group = highlightAutoCmds,
  callback = function()
    vim.fn.matchadd("Todo", "TODO")
    vim.fn.matchadd("Note", "NOTE")
    vim.fn.matchadd("Study", "STUDY")
    vim.fn.matchadd("Important", "IMPORTANT")
  end
})

----------------------------------------------------
-- CMDS

local augroup = vim.api.nvim_create_augroup("UserConfig", {})

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(ev)
    local opts = { buffer = ev.buf }

    -- Only create maps if the server actually supports them (optional)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local supports = function(method)
      return client and client.supports_method and client:supports_method(method)
    end

    if supports("textDocument/definition") then
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition,
        vim.tbl_extend("force", opts, { desc = "LSP: Go to definition" }))
    end

    if supports("textDocument/hover") then
      vim.keymap.set("n", "K", vim.lsp.buf.hover,
        vim.tbl_extend("force", opts, { desc = "LSP: Hover docs" }))
    end

    if supports("textDocument/formatting") or supports("textDocument/rangeFormatting") then
      vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format({ async = false }) end,
        vim.tbl_extend("force", opts, { desc = "LSP: Format buffer" }))
    end

    -- TODO: action seems to not be working?!
    if supports("textDocument/codeAction") then
      local code_action = function()
        -- use `{}` to avoid “cursor outside buffer” at attach-time
        vim.lsp.buf.code_action({ context = { only = { "quickfix" } } })
      end
      vim.keymap.set("n", "<leader>vca", code_action,
        vim.tbl_extend("force", opts, { desc = "LSP: Code action (fix diagnostics)" }))
      vim.keymap.set("v", "<leader>vca", code_action,
        vim.tbl_extend("force", opts, { desc = "LSP: Code action (range quickfix)" }))
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.hl.on_yank({ timeout = 100 }) -- briefly highlight yanked text
  end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

----------------------------------------------------
-- KEYMAPS

vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "File: Save" })

vim.keymap.set("n", "<leader>pf", ":Pick files<CR>", { desc = "Picker: Files" })
vim.keymap.set("n", "<leader>h", ":Pick help<CR>", { desc = "Picker: Help" })
vim.keymap.set("n", "<leader>e", ":Oil<CR>", { desc = "File explorer: Oil" })

vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y<CR>', { desc = "Clipboard: Yank" })
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d<CR>', { desc = "Clipboard: Delete" })
vim.keymap.set("v", "p", [["_dP]], { desc = "copy without losing last yield" })


-- project search
vim.keymap.set("n", "<leader>ps", function()
  local query = vim.fn.input("Search query > ")
  if query == "" then return end

  local ignores = table.concat({
    "-g '!vendor/*'",
    "-g '!node_modules/*'",
    "-g '!bin/*'",
    "-g '!dist/*'",
  }, " ")

  local base_cmd = "rg --vimgrep --no-heading --smart-case " .. ignores .. " "

  local cmd
  if query:sub(1, 1) == "/" then
    -- regex mode
    cmd = base_cmd .. vim.fn.shellescape(query:sub(2))
  else
    -- literal mode
    cmd = base_cmd .. "-F " .. vim.fn.shellescape(query)
  end

  local results = vim.fn.systemlist(cmd)
  local root = find_git_root()
  vim.fn.setqflist({}, "r", { title = "Ripgrep (" .. root .. ")", lines = results })

  -- TODO: open on same buffer
  vim.cmd("copen")
end, { desc = "Project: Search" })

vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { desc = "LSP: Show signature help" })

-- diagnostics
vim.keymap.set("n", "[d", function() vim.diagnostic.jump { count = -1 } end, { desc = "Diagnostics: Prev" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump { count = 1 } end, { desc = "Diagnostics: Next" })
vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { desc = "Diagnostics: View" })
-- vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action(), { desc = "Diagnostics: Action")
vim.keymap.set("n", "<leader>do", function() vim.diagnostic.open_float(nil, { scope = "line" }) end,
  { desc = "Diagnostics: Show line" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics: Loclist" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "join lines" })

vim.keymap.set("n", "p", "]p")  -- indent pasted text
vim.keymap.set("v", ">", ">gv") -- keep indented text selected
vim.keymap.set("v", "<", "<gv") -- keep indented text selected

-- quickfix / loclist
vim.keymap.set("n", "<leader>cc", "<cmd>lclose<CR><cmd>cclose<CR>", { desc = "Close loclist and quickfix" })
vim.keymap.set("n", "<leader>cv", toggle_qf_or_loclist, { desc = "Toggle focus loclist/quickfix" })

-- Keep cursor in the middle when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- buffer navigation
vim.keymap.set("n", "<leader>bh", "<cmd>bprevious<CR>", { desc = "Buffer: previous" })
vim.keymap.set("n", "<leader>bl", "<cmd>bnext<CR>", { desc = "Buffer: next" })
vim.keymap.set("n", "<leader>bw", "<cmd>bdelete<CR>", { desc = "Buffer: close" })
vim.keymap.set("n", "<leader>bwa", "<cmd>%bd|e#<CR>", { desc = "Buffer: close all other" })
vim.keymap.set("n", "<leader>br", "<cmd>checktime<CR>", { desc = "Buffer: refresh" })
vim.keymap.set("n", "<C-w>a", "<cmd>vsplit<CR>", { desc = "Buffer: split" })
vim.keymap.set({ "n", "v", "x" }, "<leader>s", ":e #<CR>", { desc = "File: Edit alternate file" })
-- TODO: still wondering if i like this one
vim.keymap.set({ "n", "v", "x" }, "<leader>S", ":sf #<CR>", { desc = "File: Split with alternate file" })

-- Toggle comment
vim.keymap.set("n", "<leader>/", require("Comment.api").toggle.linewise.current, { desc = "Comment:Toggle line" })
vim.keymap.set(
  "x",
  "<leader>/",
  '<ESC><CMD>lua require("Comment.api").locked("toggle.linewise")(vim.fn.visualmode())<CR>',
  { desc = "Comment: Toggle block" }
)
