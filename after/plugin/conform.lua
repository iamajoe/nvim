local conform = require("conform")

conform.setup({
	lsp_fallback = true,
	formatters_by_ft = {
		css = { "stylelint" },
		scss = { "stylelint" },
		lua = { "stylua" },
		javascript = { "eslint", { "prettierd", "prettier" } },
		typescript = { { "eslint", "tslint" }, { "prettierd", "prettier" } },
		templ = { "rustywind", "goimports", "golines", "gofmt", "templ" },
		go = { "goimports", "golines", "gofmt" },
	},
})
