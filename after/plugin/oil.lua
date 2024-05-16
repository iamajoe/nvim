require("oil").setup({
	default_file_explorer = false,
	columns = { "icon" },
	keymaps = {
		["<C-s>"] = false,
		["<C-h>"] = false,
		["<C-t>"] = false,
		["<C-p>"] = false,
		["<M-p>"] = "actions.preview",
		-- ["<M-h>"] = "actions.select_split",
	},
	view_options = {
		show_hidden = true,
	},
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
