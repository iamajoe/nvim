-- NOTE: we want to disable this one for now
if true then
	return {}
end

return {
	{
		-- focus on current scope highlight
		"folke/twilight.nvim",
		enabled = false,
		config = function()
			require("twilight").setup({
				dimming = {
					alpha = 0.15, -- amount of dimming
					-- we try to get the foreground from the highlight groups or fallback color
					color = { "Normal", "#ffffff" },
					term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
					inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
				},
				-- context = 15,          -- amount of lines we will try to show around the current line
				context = -1,
				treesitter = true, -- use treesitter when available for the filetype
				expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
					-- "function",
					-- "method",
					-- "method_definition",
					-- "table",
					-- "table_constructor",
					-- "if_statement",

					-- go
					"function_declaration",
					"method_declaration",
					"func_literal",

					-- typescript
					"class_declaration",
					"method_definition",
					"arrow_function",
					"function_declaration",
					"generator_function_declaration",
				},
				exclude = {}, -- exclude these filetypes
			})

			require("twilight").enable()
		end,
	},
}
