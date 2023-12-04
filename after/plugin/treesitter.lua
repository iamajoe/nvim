require 'nvim-treesitter.configs'.setup {
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
    }
  },

  autotag = {
    enable = true,
  },
  rainbow = { enable = true },

  playground = {
    enable = true,
    disable = {},
    updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}

-- TEMPL need extra shenanigans to work
-- local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
-- treesitter_parser_config.templ = {
--   install_info = {
--     url = "https://github.com/vrischmann/tree-sitter-templ.git",
--     files = { "src/parser.c", "src/scanner.c" },
--     branch = "master",
--   },
-- }
vim.treesitter.language.register("templ", "templ")
vim.filetype.add({
  extension = {
    templ = "templ",
  },
})
