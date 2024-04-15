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

	{ "rmagatti/goto-preview" }, -- preview the definition

	{ "folke/trouble.nvim" }, -- show diagnostics

	-- color themes
	--  'Mofiqul/dracula.nvim'
	--  'sainnhe/everforest'
	--  'rose-pine/neovim'
	{ "catppuccin/nvim" },

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

	{ "stevearc/conform.nvim", opts = {} }, -- used for formatting code

	{ "nvim-lualine/lualine.nvim" }, -- line on bottom of vim more complete
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	}, -- setup pairs when using ( or { for example

	-- go specific plugin
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
}

require("lazy").setup(plugins, {})
