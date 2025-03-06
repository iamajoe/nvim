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
					javascript = { "eslint_d", "prettier" },
					typescript = { "eslint_d", "prettier" },
					typescriptreact = { "eslint_d", "prettier" },
					json = { "prettier" },
					html = { "prettier" },
					-- nml = { "prettier" },
					markdown = { "prettier" },
					yaml = { "prettier" },
					go = { "goimports", "golines", "gofmt" },
					-- templ = { "rustywind", "templ" },
					-- templ = { "rustywind", "golines", "gofmt", "templ" },
					lua = { "stylua" },
					-- java = { "google-java-format" },
					-- cpp = { "clang_format" },
					-- cpp = { "clang_format", "cpplint" },
					-- arduino = { "clang-format" },
				},
			})
		end,
	},
}
