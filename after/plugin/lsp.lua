local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")
local util = require("lspconfig/util")
local cmp = require('cmp')

local cmp_status_ok, _ = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end


lsp.preset("recommended")
lsp.ensure_installed({
  'lua_ls',
  'jsonls',
  'dockerls',
  'bashls',
  'html',
  'cssls',
  'gopls',
  'sqlls',
  'eslint',
  'tsserver',
  'templ',
})

-- Fix Undefined global 'vim'
lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

-- Fix Undefined global 'vim'
-- lsp.configure('lua-language-server', {
--     settings = {
--         Lua = {
--             diagnostics = {
--                 globals = { 'vim' }
--             }
--         }
--     }
-- })

lspconfig.gopls.setup({
  -- cmd = { "gopls", '-remote=auto', '-remote.listen.timeout=5m', 'serve' },
  cmd = { "gopls", 'serve' },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
        assign = true,
        bools = true,
      },
      staticcheck = true,
      linksInHover = false,
      codelenses = {
        generate = true,
        gc_details = true,
        regenerate_cgo = true,
        tidy = true,
        upgrade_depdendency = true,
        vendor = true,
      }
    }
  }
})

-- SQL shenanigans
lspconfig.sqlls.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  filetypes = { 'sql' },
  root_dir = function(_)
    return vim.loop.cwd()
  end,
})

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
  ['<Tab>'] = cmp.mapping(function(fallback)
    local copilot_keys = vim.fn['copilot#Accept']()
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif copilot_keys ~= '' and type(copilot_keys) == 'string' then
      vim.api.nvim_feedkeys(copilot_keys, 'i', true)
    else
      fallback()
    end
  end, {
    'i',
    's',
  }),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

-- lsp.setup_nvim_cmp({
cmp.setup({
  sources = {
    -- { name = "copilot",  group_index = 2 },
    { name = "path",     group_index = 2 },
    { name = "nvim_lsp", group_index = 2 },
    { name = "nvim_lua" },
    { name = "buffer",   group_index = 3, keyword_length = 3 },
    { name = "luasnip" },
    -- { name = "buffer",   keyword_length = 3 },
    -- { name = "luasnip",  keyword_length = 2, group_index = 2 },
  },
  mapping = cmp_mappings,
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  }
})

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

function FormatFile()
  -- we want to ignore when we are in netrw
  if vim.o.ft == "netrw" or vim.o.ft == "oil" then
    return
  end

  if vim.o.ft == "typescript" then
    -- if vim.o.ft == "javascript" or vim.o.ft == "typescript" then
    vim.cmd("EslintFixAll")
  elseif vim.o.ft == "sql" then
    -- do nothing when sql, we dont have a formatter for it
  else
    vim.lsp.buf.format({})
  end

  -- remove whitespace
  vim.cmd([[%s/\s\+$//e]])
end

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("n", "ff", FormatFile, opts)
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = FormatFile
})

-- TEMPL shenanigans
-- https://vi.stackexchange.com/questions/42926/how-do-i-add-a-custom-lsp-to-nvim-lspconfig
require('lspconfig.configs').templ = {
  default_config = {
    cmd = { "templ", "lsp" },
    filetypes = { 'templ' },
    root_dir = lspconfig.util.root_pattern("go.mod"),
    settings = {},
  },
}
vim.cmd([[autocmd BufRead,BufNewFile *.templ setfiletype templ]])
