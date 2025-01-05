-- auto-reload files when modified externally
-- https://unix.stackexchange.com/a/383044
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})

-- whenever there is an yank, it highlights
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 100 })
	end,
})

-- handle on save (before)
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		local bufnr = args.buf

		-- Disable autoformat on certain filetypes
		-- local ignore_filetypes = { "sql", "java" }
		local ignore_filetypes = { "netrw", "oil" }
		if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
			return
		end

		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		--
		-- Disable autoformat for files in a certain path
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if bufname:match("/node_modules/") then
			return
		end

		require("conform").format({ bufnr = bufnr, lsp_fallback = true })
	end,
})

-- handle on save (after)
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	callback = function()
		require("lint").try_lint()
	end,
})
