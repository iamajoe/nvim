-- require("noice").setup({
--   lsp = {
--     enabled = false,
--     progress = {
--       enabled = false,
--     },
--     hover = {
--       enabled = false,
--     },
--     signature = {
--       enabled = false,
--     },
--     message = {
--       enabled = false,
--     },
--     documentation = {
--       enabled = false,
--     },
--     -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
--     override = {
--       ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
--       ["vim.lsp.util.stylize_markdown"] = true,
--       ["cmp.entry.get_documentation"] = true,
--     },
--   },
--   -- you can enable a preset for easier configuration
--   presets = {
--     bottom_search = false,         -- use a classic bottom cmdline for search
--     command_palette = true,        -- position the cmdline and popupmenu together
--     long_message_to_split = false, -- long messages will be sent to a split
--     inc_rename = false,            -- enables an input dialog for inc-rename.nvim
--     lsp_doc_border = false,        -- add a border to hover docs and signature help
--   },
--   cmdline = {
--     enabled = true,
--     view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
--     opts = {
--       position = "40%",
--       size = {
--         width = "50%",
--         -- height = "10%"
--       },
--       border = {
--         style = "single",
--       },
--       --win_options = {
--       --  winhighlight = "Normal:Normal,FloatBorder:Normal",
--       --},
--     }, -- global options for the cmdline. See section on views
--     ---@type table<string, CmdlineFormat>
--     format = {
--       -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
--       -- view: (default is cmdline view)
--       -- opts: any options passed to the view
--       -- icon_hl_group: optional hl_group for the icon
--       -- title: set to anything or empty string to hide
--       cmdline = { pattern = "^:", icon = ">", lang = "vim" },
--       search_down = { kind = "search", pattern = "^/", icon = "?", lang = "regex" },
--       search_up = { kind = "search", pattern = "^%?", icon = "?", lang = "regex" },
--       filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
--       lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "L", lang = "lua" },
--       help = { pattern = "^:%s*he?l?p?%s+", icon = "H" },
--       input = {}, -- Used by input()
--       -- lua = false, -- to disable a format, set to `false`
--     },
--   },
--   messages = {
--     enabled = false,
--     -- NOTE: If you enable messages, then the cmdline is enabled automatically.
--     -- This is a current Neovim limitation.
--     view = false,                --"notify",             -- default view for messages
--     view_error = "notify",       -- view for errors
--     view_warn = "notify",        -- view for warnings
--     view_history = "messages",   -- view for :messages
--     view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
--   },
--   commands = {
--     enabled = false,
--   },
--   notify = {
--     enabled = false,
--   },
--   markdown = {
--     enabled = false,
--   },
--   smart_move = {
--     enabled = false,
--   },
--   popupmenu = {
--     enabled = true,  -- enables the Noice popupmenu UI
--     ---@type 'nui'|'cmp'
--     backend = "nui", -- backend to use to show regular cmdline completions
--     ---@type NoicePopupmenuItemKind|false
--     -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
--     kind_icons = false -- {}, -- set to `false` to disable icons
--   },
-- })

require("notify").setup({
  stages = "static",
  on_open = nil,
  on_close = nil,
  render = "default",
  timeout = 5000,
  -- background_colour = "Normal",
  background_colour = "#000000",
  minimum_width = 50,
  icons = {
    ERROR = "E",
    WARN = "W",
    INFO = "I",
    DEBUG = "D",
    TRACE = "T",
  },
})

vim.notify = require("notify")

require("dressing").setup({
  input = {
    prefer_width = 0.4,
    win_options = {
      winhighlight = 'NormalFloat:DiagnosticError'
    }
  },
  select = {
    -- backend = { "nui", "telescope" },
    backend = { "telescope", "nui", "builtin" },
    --backend = { "nui", "telescope", "fzf_lua", "fzf", "builtin" },
    nui = {
      position = "40%",
      size = {
        width = "50%",
        -- height = "10%"
      },
      border = {
        style = "single",
      },
    }
  }
})
