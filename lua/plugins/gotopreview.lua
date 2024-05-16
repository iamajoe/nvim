return {
	{
		-- preview the definition
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({})
			vim.keymap.set(
				"n",
				"<leader>gp",
				"<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
				{ noremap = true }
			) -- show preview of code
		end,
	},
}
