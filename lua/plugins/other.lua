return {
	{ "nvim-lua/plenary.nvim" },
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter" },
	},
	{
		-- setup pairs when using ( or { for example
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
}
