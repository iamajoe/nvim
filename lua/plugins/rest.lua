return {
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
		opts = {
			rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
		},
	},
	{
		"rest-nvim/rest.nvim",
		ft = "http",
		dependencies = { "luarocks.nvim" },
		config = function()
			require("rest-nvim").setup({
				keybinds = {
					{
						"<leader>rr",
						"<cmd>Rest run<cr>",
						"Run request under the cursor",
					},
				},
				result = {
					split = {
						horizontal = false,
						in_place = true,
						stay_in_current_window_after_split = false,
					},
				},
				highlight = {
					enable = false,
				},
			})
		end,
	}, -- highlights current pattern match
}
