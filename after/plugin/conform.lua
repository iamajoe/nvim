local conform = require("conform")

conform.setup({
	lsp_fallback = true,
	formatters_by_ft = {
		css = { "stylelint" },
		scss = { "stylelint" },
		lua = { "stylua" },
		javascript = { "eslint", { "prettier" } },
		typescript = { { "eslint", "tslint" }, { "prettier" } },
		templ = { "rustywind", "golines", "gofmt", "templ" },
		go = { "goimports", "golines", "gofmt" },
	},
})
