require("notify").setup({
  stages = "static",
  on_open = nil,
  on_close = nil,
  render = "default",
  timeout = 5000,
  background_colour = "Normal",
  minimum_width = 50,
  icons = {
    ERROR = "E",
    WARN = "W",
    INFO = "I",
    DEBUG = "D",
    TRACE = "✎",
  },
})

vim.notify = require("notify")
