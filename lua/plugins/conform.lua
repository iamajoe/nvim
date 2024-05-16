-- used for formatting code
return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			local conform = require("conform")

			conform.setup({
				lsp_fallback = true,
				formatters_by_ft = {
					css = { "stylelint" },
					scss = { "stylelint" },
					lua = { "stylua" },
					javascript = { "eslint", { "prettier" } },
					typescript = { { "eslint", "tslint" }, { "prettier" } },
					templ = { "rustywind", "templ" },
					-- templ = { "rustywind", "golines", "gofmt", "templ" },
					go = { "goimports", "golines", "gofmt" },
				},
			})
		end,
	},
}
