-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end
  }

  use 'rcarriga/nvim-notify'       -- notification window
  use({ 'rmagatti/goto-preview' }) -- preview the definition

  use({ "folke/trouble.nvim" })    -- show diagnostics

  use({
    "utilyre/barbecue.nvim",
    tag = "*",
    requires = {
      "SmiteshP/nvim-navic",
    },
  }) -- show winbar with file info

  -- color themes
  -- use 'Mofiqul/dracula.nvim'
  -- use 'sainnhe/everforest'
  -- use 'rose-pine/neovim'
  use 'catppuccin/nvim'

  use({ 'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' } })
  use({ 'nvim-treesitter/nvim-treesitter-context' }) -- shows the signature of the method you are in
  use { 'windwp/nvim-ts-autotag', after = 'nvim-treesitter' }
  use({ 'nvim-lua/plenary.nvim' })
  -- use({ 'nvim-pack/nvim-spectre' }) -- search and replace
  use({ 'ThePrimeagen/harpoon' }) -- mark a file to be on a separate list
  -- use({ 'mbbill/undotree' }) -- tree to show past undos
  -- use({ 'tpope/vim-fugitive' })   -- git
  use "lukas-reineke/indent-blankline.nvim"

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },             -- Required
      { 'williamboman/mason.nvim' },           -- Optional
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  }

  use 'jose-elias-alvarez/null-ls.nvim' -- used for formatting code
  use {
    "olexsmir/gopher.nvim",
    requires = { -- dependencies
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  } -- nice to haves when working with go

  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {
        ignore_missing = true,
        show_help = false
      }
    end
  }

  -- TODO: need to solve, having issues regarding to parent
  -- use { 'stevearc/oil.nvim' } -- vim vinegar kind of file system tree but with buffer like

  -- use({
  --     "kylechui/nvim-surround",
  --     tag = "*", -- Use for stability; omit to use `main` branch for the latest features
  --     config = function()
  --         require("nvim-surround").setup({
  --             -- Configuration here, or leave empty to use defaults
  --         })
  --     end
  -- })

  -- Official copilot plugin has some usage issues
  -- use "github/copilot.vim"
  use {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",

    config = function()
      require('copilot').setup({
        panel = { enabled = false, },
        suggestion = { enabled = false, },
      })
    end,
  }
  use {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end
  }

  use 'nvim-lualine/lualine.nvim'

  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- require('packer').sync()
end)
