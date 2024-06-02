local treesitterConfig = {
	ensure_installed = {
		"bash",
		"c",
		"css",
		"dockerfile",
		"gitcommit",
		"git_rebase",
		"go",
		"gomod",
		"gosum",
		"gowork",
		"graphql",
		"html",
		"java",
		"javascript",
		"jsdoc",
		"json",
		"lua",
		"make",
		"query",
		"rust",
		"scss",
		"sql",
		"svelte",
		"templ",
		"terraform",
		"toml",
		"typescript",
		"vim",
		"vimdoc",
		"vue",
		"yaml",
	},
	sync_install = false,
	auto_install = true,

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true }, -- type '=' operator to fix indentation

	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-space>",
			node_incremental = "<C-space>",
			scope_incremental = false,
			node_decremental = "<bs>",
		},
	},

	autotag = {
		enable = true,
	},
	rainbow = { enable = true },

	playground = {
		enable = true,
		disable = {},
		updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
		persist_queries = false, -- Whether the query persists across vim sessions
		keybindings = {
			toggle_query_editor = "o",
			toggle_hl_groups = "i",
			toggle_injected_languages = "t",
			toggle_anonymous_nodes = "a",
			toggle_language_display = "I",
			focus_language = "f",
			unfocus_language = "F",
			update = "R",
			goto_node = "<cr>",
			show_help = "?",
		},
	},
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"vrischmann/tree-sitter-templ", -- syntax for a-h/templ (go templ for html)
		},
		config = function()
			require("nvim-treesitter.configs").setup(treesitterConfig)
			--
			-- TEMPL need extra shenanigans to work
			-- TODO: investigate why this errors
			--       to make templ work, uncomment the code and run :TSInstall templ
			--       then comment back again so it doesnt error
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.templ = {
				install_info = {
					url = "https://github.com/vrischmann/tree-sitter-templ.git",
					files = { "src/parser.c", "src/scanner.c" },
					branch = "master",
				},
				filetype = "templ",
			}
		end,
	},
	-- { "nvim-treesitter/playground" }, -- show the tree for treesitter context
}
