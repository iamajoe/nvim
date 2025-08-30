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

				format_after_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},

				formatters_by_ft = {
					css = { "stylelint" },
					-- scss = { "stylelint" },
					javascript = { "eslint_d", "prettierd" },
					typescript = { "eslint_d", "prettierd" },
					typescriptreact = { "eslint_d", "prettierd" },
					json = { "prettierd" },
					html = { "prettierd" },
					rust = { "rustfmt" },
					-- nml = { "prettier" },
					markdown = { "prettierd" },
					yaml = { "prettierd" },
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
