require("nvim_context_vt").setup({
	enabled = true,
	min_rows = 3,
})

require("treesitter-context").setup({
	enable = true,
	max_lines = 2,
	min_window_height = 0,
	line_numbers = true,
	multiline_threshold = 4,
	trim_scope = "outer",
	mode = "cursor",
	separator = nil,
	zindex = 20,
	on_attach = nil,
})
