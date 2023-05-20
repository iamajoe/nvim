require('goto-preview').setup {}
vim.keymap.set("n", "<leader>gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true })
