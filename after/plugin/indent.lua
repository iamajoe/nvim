-- indent-blankline

-- vim.cmd [[highlight IndentBlanklineIndent1 guifg=#111111 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent2 guifg=#333333 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineContextChar guifg=#ff5555 gui=nocombine]]

-- require("ibl").setup {
-- show_end_of_line = true,
-- char_highlight_list = {
--   "IndentBlanklineIndent1",
--   "IndentBlanklineIndent2",
-- },
-- show_current_context = true,
-- show_current_context_start = true,
-- }

local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  -- vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
  -- vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
  -- vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
  -- vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
  -- vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
  -- vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
  -- vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })

  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#171717" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#444444" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#171717" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#444444" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#171717" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#444444" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#171717" })
end)

require("ibl").setup { indent = { highlight = highlight } }
