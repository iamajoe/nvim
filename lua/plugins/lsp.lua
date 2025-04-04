return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			-- { "williamboman/mason.nvim" }, -- Optional
			-- { "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{
				"hrsh7th/nvim-cmp",
				dependencies = {
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
		},
		config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
			require("./plugins/configs/lsp")
		end,
	},
}
