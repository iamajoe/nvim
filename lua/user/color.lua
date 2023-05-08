-- change cursor line
function ColorCursorLine()
  local colors = {
    bg = "#202328",
    fg = "#bbc2cf",
    yellow = "#ECBE7B",
    cyan = "#008080",
    darkblue = "#081633",
    green = "#3d5122",
    orange = "#FF8800",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    blue = "#51afef",
    red = "#6f3328",
  }

  local mode_color = {
    n = colors.red,
    i = colors.green,
    v = colors.yellow,
    V = colors.blue,
    c = colors.magenta,
    no = colors.red,
    s = colors.orange,
    S = colors.orange,
    ic = colors.yellow,
    R = colors.violet,
    Rv = colors.violet,
    cv = colors.red,
    ce = colors.red,
    r = colors.cyan,
    rm = colors.cyan,
    tr = colors.red,
  }

  local color = mode_color[vim.api.nvim_get_mode().mode]
  if color == nil then
    color = "#1c1c1c"
  end

  -- TODO: investigate why color not working
  color = "#1c1c1c"

  print(vim.api.nvim_get_mode().mode)
  -- vim.api.nvim_command("hi! CursorLine guifg=NONE guibg=".. color)
  vim.api.nvim_command("hi! CursorLine guifg=NONE guibg=" .. color)
  -- vim.api.nvim_command("hi! CursorLine guifg=NONE guibg=#ff0000" )
end

vim.api.nvim_command([[autocmd ModeChanged * lua ColorCursorLine()]])
vim.api.nvim_command("hi! CursorLine guifg=NONE guibg=#1c1c1c")

-- modify catppuccin
require("catppuccin").setup {
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  term_colors = true,
  transparent_background = false,
  no_italic = false,
  no_bold = false,
  styles = {
    comments = {},
    conditionals = {},
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
  },
  color_overrides = {
    mocha = {
      base = "#000000",
      mantle = "#000000",
      crust = "#000000",
    },
  },
  highlight_overrides = {
    mocha = function(C)
      return {
        TabLineSel = { bg = C.pink },
        CmpBorder = { fg = C.surface2 },
        Pmenu = { bg = C.none },
        TelescopeBorder = { link = "FloatBorder" },
      }
    end,
  },
}

-- select color theme
function ColorTheme(color)
  color = color or "catppuccin"
  -- color = color or "rose-pine"
  -- color = color or "dracula"
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorTheme()
