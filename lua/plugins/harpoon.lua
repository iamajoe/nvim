local harpoonKeymaps = function()
	local harpoon = require("harpoon")

	vim.keymap.set("n", "<C-e>", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end)
	vim.keymap.set("n", "<leader>a", function()
		harpoon:list():add()
	end)
	vim.keymap.set("n", "<C-h>", function()
		harpoon:list():prev()
	end)
	vim.keymap.set("n", "<C-l>", function()
		harpoon:list():next()
	end)
end

-- mark a file to be on a separate list
return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("harpoon"):setup({})
			harpoonKeymaps()
		end,
	},
}
