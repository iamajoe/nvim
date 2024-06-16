local keymaps = function()
	vim.keymap.set("n", "<leader>vrr", "<cmd>Lspsaga finder<CR>", { desc = "Show method usage" })
	vim.keymap.set("n", "<leader>vo", "<cmd>Lspsaga outline<CR>", { desc = "Show outline" })
	vim.keymap.set("n", "<leader>vrn", "<cmd>Lspsaga rename<CR>", { desc = "Rename reference" })
end

return {
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({
				lightbulb = {
					enable = false,
				},
				code_action_prompt = {
					enable = false,
				},
				outline = {
					win_position = "left",
					close_after_jump = true,
					layout = "float",
				},
			})
			keymaps()
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
