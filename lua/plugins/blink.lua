-- Autocompletion
return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = { "rafamadriz/friendly-snippets" },

	-- use a release tag to download pre-built binaries
	version = "1.*",
	opts = {
		keymap = {
			preset = "default",
			["<C-d>"] = { "show", "show_documentation", "hide_documentation" },
			-- ["<C-u>"] = { "scroll_documentation_up", "fallback" },
			-- ["<C-d>"] = { "scroll_documentation_down", "fallback" },
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		signature = {
			enabled = true,
			window = {
				border = "single",
				max_width = math.floor(vim.o.columns * 0.8),
				max_height = math.floor(vim.o.lines * 0.8),
			},
			trigger = {
				show_on_trigger_character = true,
				show_on_insert = true,
			},
		},
		completion = {
			accept = {
				auto_brackets = {
					enabled = false,
				},
			},
			trigger = {
				show_on_accept_on_trigger_character = false,
			},
			list = {
				selection = {
					preselect = false,
					auto_insert = false,
				},
			},
			keyword = {
				range = "full",
			},
			ghost_text = {
				enabled = false,
				show_with_selection = true,
				show_without_selection = false,
				show_with_menu = true,
			},
			menu = {
				border = "single",
				draw = {
					gap = 1,
					padding = 1,
					treesitter = { "lsp" },
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 100,
				treesitter_highlighting = true,
				window = {
					border = "single",
					max_width = math.floor(vim.o.columns * 0.8),
					max_height = math.floor(vim.o.lines * 0.8),
				},
			},
		},
	},
	opts_extend = { "sources.default" },

	-- config = function()
	-- 	-- TODO: ...
	-- end,
}
