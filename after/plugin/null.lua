local null_ls = require("null-ls")
-- local h = require("null-ls.helpers")
-- local u = require("null-ls.utils")

local sources = {
  null_ls.builtins.diagnostics.tsc,
  null_ls.builtins.formatting.prettier,
  -- null_ls.builtins.formatting.gofmt,
  -- null_ls.builtins.formatting.goimports,
  null_ls.builtins.formatting.gofumpt,
  null_ls.builtins.formatting.goimports_reviser,
  null_ls.builtins.formatting.golines,
}
-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  sources = sources,
  debounce = 250,
  default_timeout = 2000

  -- NOT NEEDED, ALREADY HANDLED
  -- on_attach = function(client, bufnr)
  --   if client.supports_method("textDocument/formatting") then
  --     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       group = augroup,
  --       buffer = bufnr,
  --       callback = function()
  --         vim.lsp.buf.format({
  --           bufnr = bufnr,
  --           filter = function(client)
  --             return client.name ~= "volar"
  --           end,
  --         })
  --       end,
  --     })
  --   end
  -- end,
})
