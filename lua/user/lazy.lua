local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
		},
	},
	{
		"nvim-telescope/telescope-file-browser.nvim", -- sets a file browser through telescope
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{ "gbprod/yanky.nvim", dependencies = { "kkharji/sqlite.lua" } }, -- shows yank history on telescope

	{
		"stevearc/dressing.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	}, -- better inputs on neovim
	-- { 'rcarriga/nvim-notify' },                                           -- notification window
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
	{ "rmagatti/goto-preview" }, -- preview the definition

	{ "folke/trouble.nvim" }, -- show diagnostics

	-- {
	--   "utilyre/barbecue.nvim",
	--   name = "barbecue",
	--   version = "*",
	--   dependencies = { "SmiteshP/nvim-navic" },
	-- }, -- show winbar with file info

	-- color themes
	--  'Mofiqul/dracula.nvim'
	--  'sainnhe/everforest'
	--  'rose-pine/neovim'
	{ "catppuccin/nvim" },

	-- ({ 'unblevable/quick-scope'  }) -- highlights when using f F t T
	{ "chrisgrieser/nvim-early-retirement" }, -- closes buffers when they have been inactive for a long time
	{ "rktjmp/highlight-current-n.nvim" }, -- highlights current pattern match

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"vrischmann/tree-sitter-templ", -- syntax for a-h/templ (go templ for html)
		},
	},
	{ "nvim-treesitter/nvim-treesitter-context" }, -- shows the signature of the method you are in
	{ "nvim-treesitter/playground" }, -- show the tree for treesitter context

	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter" },
	},
	{ "nvim-lua/plenary.nvim" },
	-- ({ 'nvim-pack/nvim-spectre' }) -- search and replace
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	}, -- mark a file to be on a separate list
	-- ({ 'mbbill/undotree' }) -- tree to show past undos
	-- ({ 'tpope/vim-fugitive' })   -- git
	-- { "lukas-reineke/indent-blankline.nvim",    main = "ibl",                        opts = {} },
	{ "folke/twilight.nvim" }, -- focus on current scope highlight

	{ "numToStr/Comment.nvim" },
	{ "haringsrob/nvim_context_vt" }, -- setups context on the brackets

	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{ "williamboman/mason.nvim" }, -- Optional
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- auto completion
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" }, -- gives vim command line auto completion
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" }, -- auto completion glue
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{
				"L3MON4D3/LuaSnip",
				version = "v2.1.1",
				build = "make install_jsregexp",
				dependencies = { "rafamadriz/friendly-snippets" },
			},
		},
	},

	-- { 'jose-elias-alvarez/null-ls.nvim' }, -- used for formatting code
	{ "stevearc/conform.nvim", opts = {} },
	{
		"olexsmir/gopher.nvim", -- nice to haves when working with go
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},

	-- { 'joerdav/templ.vim' }, -- syntax for a-h/templ (go templ for html)

	{ "folke/which-key.nvim" }, -- gives a cheatsheet of shortcuts when pressing a key

	{ "nvim-lualine/lualine.nvim" }, -- line on bottom of vim more complete
	{ "windwp/nvim-autopairs" }, -- setup pairs when using ( or { for example
}

require("lazy").setup(plugins, {})
