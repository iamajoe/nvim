local conform = require("conform")

conform.setup({
  lsp_fallback = true,
  formatters_by_ft = {
    css = { "stylelint" },
    scss = { "stylelint" },
    lua = { "stylua" },
    templ = { "rustywind", "templ" },
    javascript = { "eslint", { "prettierd", "prettier" } },
    typescript = { {"eslint", "tslint"}, { "prettierd", "prettier" } },
    go = {
      {
        command = "goimports-reviser",
        args = {"-file-path", "%filepath"},
      },
      "golines",
      { "gofumpt", "gofmt" },
    },
  },
  format_on_save = function(bufnr)
    -- Disable autoformat on certain filetypes
    -- local ignore_filetypes = { "sql", "java" }
    local ignore_filetypes = {"netrw", "oil"}
    if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
      return
    end

    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end

    -- Disable autoformat for files in a certain path
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname:match("/node_modules/") then
      return
    end

    return { timeout_ms = 200, lsp_fallback = true }
  end,
})
