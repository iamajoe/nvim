-- used for formatting code
return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			local conform = require("conform")

			conform.setup({
				lsp_fallback = true,
				async = true,

				formatters_by_ft = {
					css = { "stylelint" },
					-- scss = { "stylelint" },
					javascript = { "eslint_d", "prettier" },
					typescript = { "eslint_d", "prettier" },
					typescriptreact = { "eslint_d", "prettier" },
					json = { "prettier" },
					html = { "prettier" },
          rust = { "rustfmt" },
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

			-- Customise the default "prettier" command to format Markdown files as well
			-- conform.formatters.prettier = {
			-- 	prepend_args = { "--prose-wrap", "always" },
			-- }
		end,
	},
}
