local utils = require("yanky.utils")
local mapping = require("yanky.telescope.mapping")

require("yanky").setup({
  picker = {
    select = {
      action = nil, -- nil to use default put action
    },
    telescope = {
      use_default_mappings = false,
      mappings = {
        default = mapping.put("p"),
        i = {
          ["<c-p>"] = mapping.put("p"),
          -- ["<c-k>"] = mapping.put("P"),
          ["<c-x>"] = mapping.delete(),
          ["<c-r>"] = mapping.set_register(utils.get_default_register()),
        },
        n = {
          p = mapping.put("p"),
          -- P = mapping.put("P"),
          d = mapping.delete(),
          r = mapping.set_register(utils.get_default_register())
        },
      }
    }
  },
  highlight = {
    on_put = false,
    on_yank = false,
    timer = 1,
  },
})

vim.keymap.set("n", "<leader>p", "<cmd>Telescope yank_history<CR>")
