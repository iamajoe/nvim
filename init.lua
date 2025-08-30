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

vim.g.mapleader = " "

----------------------------------------------------
-- KEYMAPS

vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "File: Save" })

vim.keymap.set("n", "<leader>f", ":Pick files<CR>", { desc = "Picker: Files" })
vim.keymap.set("n", "<leader>h", ":Pick help<CR>", { desc = "Picker: Help" })
vim.keymap.set("n", "<leader>e", ":Oil<CR>", { desc = "File explorer: Oil" })

vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y<CR>', { desc = "Clipboard: Yank" })
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d<CR>', { desc = "Clipboard: Delete" })

-- diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostics: Prev" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostics: Next" })
vim.keymap.set("n", "<leader>do", function()
  vim.diagnostic.open_float(nil, { scope = "line" })
end, { desc = "Diagnostics: Show line" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics: Loclist" })
vim.keymap.set("n", "<leader>dlc", ":lclose<CR>", { desc = "Diagnostics: Loclist" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "join lines" })

vim.keymap.set("n", "p", "]p")  -- indent pasted text
vim.keymap.set("v", ">", ">gv") -- keep indented text selected
vim.keymap.set("v", "<", "<gv") -- keep indented text selected

-- Keep cursor in the middle when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Buffer navigation
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
vim.keymap.set("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment line" })
vim.keymap.set("x", "<leader>/", function()
  require("comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "comment: toggle selection" })

vim.keymap.set("i", "<leader><leader>qi", "<ESC>", { desc = "Input mode escape" })

----------------------------------------------------
-- PLUGINS

vim.pack.add({
  { src = "https://github.com/catppuccin/nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/echasnovski/mini.pick" },
  { src = "https://github.com/numToStr/Comment.nvim" },
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

-- TODO: auto completion isnt great

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }

    -- Only create maps if the server actually supports them (optional)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local supports = function(method)
      return client and client.supports_method and client:supports_method(method)
    end

    -- setup completion
    if supports('textDocument/completion') and client then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
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

    -- TODO: action seems to not be working
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
vim.cmd("set completeopt+=noselect")

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.hl.on_yank({ timeout = 100 }) -- briefly highlight yanked text
  end,
})
