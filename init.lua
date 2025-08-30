----------------------------------------------------
-- GENERAL SETTINGS

-- Appearance / UI
vim.opt.number = true         -- show absolute line numbers
vim.opt.relativenumber = true -- show relative line numbers (except current)
vim.opt.cursorline = true     -- highlight the current line
vim.opt.colorcolumn = "90"    -- highlight column 90
vim.opt.signcolumn = "yes"    -- always show the sign column
vim.opt.showtabline = 1       -- show tabline only if multiple tabs
vim.opt.winborder = "rounded" -- use rounded window borders in popups
vim.opt.termguicolors = true  -- enable 24-bit colors

-- Indentation / Tabs
vim.opt.expandtab = true   -- convert tabs to spaces
vim.opt.tabstop = 2        -- how many spaces a literal <Tab> shows as
vim.opt.shiftwidth = 2     -- spaces for each step of (auto)indent
vim.opt.softtabstop = 2    -- spaces a <Tab> counts for while editing
vim.opt.smartindent = true -- smart auto-indenting on new lines

-- Search
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.hlsearch = false  -- don't highlight search matches after Enter
vim.opt.incsearch = true  -- show search matches as you type

-- Scrolling / navigation
vim.opt.scrolloff = 8 -- keep 8 lines visible when scrolling
vim.opt.wrap = false  -- don't wrap long lines

-- Files / persistence
vim.opt.swapfile = false                               -- don't create swap files
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- dir for undo history
vim.opt.undofile = true                                -- keep undo history across sessions
vim.opt.fileencoding = "utf-8"                         -- file encoding to use when writing
vim.opt.isfname:append("@-@")                          -- treat "@-@" as part of filenames
vim.opt.switchbuf = { "useopen", "usetab", "newtab" }  -- eg.: quickfix open on new tab

-- Ripgrep
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.g.mapleader = " "

vim.diagnostic.config({
  signs = {
    linehl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    },
  },
  underline = true,
  update_in_insert = false,
  virtual_lines = { current_line = true, },
  virtual_text = false,
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
    vim.cmd("wincmd p")  -- jump to previous window
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

----------------------------------------------------
-- PLUGINS

vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },                        -- file explorer
  { src = "https://github.com/echasnovski/mini.pick" },                    -- pick files
  { src = "https://github.com/numToStr/Comment.nvim" },                    -- toggle comment
  { src = "https://github.com/Saghen/blink.cmp",     version = "v1.6.0" }, -- autocompletion
  { src = "https://github.com/catppuccin/nvim" },                          -- theme

  -- NOTE: still deciding if i should use basic vim color groups
  -- { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  -- NOTE: decided to use manual config per language that way i have more control
  --       i copy the files from lspconfig whenever i need them and it is one less
  --       dependency. it is not as simple as using the dependency though because
  --       i have updated the configuration files with tweaks. check that first
  -- { src = "https://github.com/neovim/nvim-lspconfig" },
})

require "mini.pick".setup()
-- NOTE: still deciding if i should use basic vim color groups
-- require "nvim-treesitter.configs".setup({
--  ensure_installed = { "typescript", "javascript", "html", "css" },
--  highlight = { enable = true },
-- })

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

vim.lsp.enable({ "lua_ls", "rust_analyzer", "ts_ls" })
-- NOTE: if you don't want to use custom files but lspconfig here is an example...
-- vim.lsp.config("lua_ls", { settings = { Lua = { ... } } })

----------------------------------------------------
-- THEME

require "catppuccin".setup({ flavour = "mocha", transparent_background = true })
vim.cmd("colorscheme catppuccin")
vim.cmd("hi statusline guibg=NONE")

----------------------------------------------------
-- CMDS

vim.api.nvim_create_autocmd("LspAttach", {
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
  pattern = "*",
  callback = function()
    vim.hl.on_yank({ timeout = 100 }) -- briefly highlight yanked text
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
