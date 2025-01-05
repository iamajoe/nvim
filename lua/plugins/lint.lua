-- used for formatting code
return {
	{
		"mfussenegger/nvim-lint",
		opts = {},
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				-- REF: we don't want these otherwise, it will duplicate errors
				-- javascript = { "eslint_d" },
				-- typescript = { "eslint_d" },
				-- typescriptreact = { "eslint_d" },
				cpp = { "cpplint" },
				arduino = { "cpplint" },
			}
		end,
	},
}
