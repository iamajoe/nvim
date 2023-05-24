vim.g.mapleader = " "

-- Show keymaps
vim.keymap.set("n", "<leader>km", ":Telescope keymaps<CR>")

-- Move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move line down in visual" })
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv==", { desc = "move line down in visual" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move line up in visual" })
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv==", { desc = "move line up in visual" })

-- Join lines
vim.keymap.set("n", "J", "mzJ`z", { desc = "join lines" })

-- Keep cursor in the middle when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Copy without losing last yield
-- vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "copy without losing last yield" })
vim.keymap.set("v", "p", [["_dP]], { desc = "copy without losing last yield" })

-- Copy to system clipboard
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Copy from system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>Y', '"+yg_', { desc = 'Copy from system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>P', '"+P', { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"_d', { desc = 'Remove without losing clipboard' })

-- Quick fix navigation
-- vim.keymap.set("n", "<-r>", "[[:cdo s/old/new/gc")
vim.keymap.set("n", "<C-r>a", "[[:cdo s/old/new/g")
vim.keymap.set("n", "<C-s>", "<cmd>cdo w<CR>")
vim.keymap.set("n", "<C-w>", "<cmd>cdo bd<CR>")
vim.keymap.set("n", "<C-q>", "<cmd>close<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Buffer navigation
-- vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "buffer next" })
vim.keymap.set("n", "<leader>bh", "<cmd>bprevious<CR>", { desc = "buffer previous" })
vim.keymap.set("n", "<leader>bl", "<cmd>bnext<CR>", { desc = "buffer next" })
vim.keymap.set("n", "<leader>bw", "<cmd>bdelete<CR>", { desc = "close buffer" })
vim.keymap.set("n", "<leader>ba", ":Telescope buffers<CR>", { desc = "list buffers" })
vim.keymap.set("n", "<leader>br", "<cmd>checktime<CR>", { desc = "refresh buffer" })

-- Search and replace highlighted word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "search and replace cursor word" })

-- Copy current file
vim.keymap.set("n", "<leader>cf", "", {
  callback = function()
    if vim.bo.filetype == "netrw" then
      vim.cmd("let netrw_selected_file=getcwd() .. '/' .. netrw#Call('NetrwGetWord')")
      vim.cmd("let netrw_copy_to_file=input('Copy to > ', netrw_selected_file)")
      vim.cmd("silent exec '!cp ' .. netrw_selected_file .. ' ' .. netrw_copy_to_file")
      vim.cmd("e .")
    else
      vim.cmd [[silent exec "!cp '%:p' '%:p:h/%:t:r.bkp.%:e'"]]
    end
  end,
  desc = "duplicate current file"
})

vim.keymap.set("n", "p", "]p")  -- indent pasted text
vim.keymap.set("v", ">", ">gv") -- keep indented text selected
vim.keymap.set("v", "<", "<gv") -- keep indented text selected
