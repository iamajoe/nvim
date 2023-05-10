vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-c>a", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-c>q", 'copilot#Dismiss()', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-c>n", 'copilot#Next()', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-c>s", 'copilot#Suggest()', { silent = true, expr = true })
