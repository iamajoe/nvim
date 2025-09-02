local actions = require("telescope.actions")

-- method to quickly send to quickfix and replace
local search_replace = function(prompt_bufnr)
	local action_state = require("telescope.actions.state")
	local from_entry = require("telescope.from_entry")

	-- DEV: copied from telescope codebase
	local entry_to_qf = function(entry)
		local text = entry.text

		if not text then
			if type(entry.value) == "table" then
				text = entry.value.text
			else
				text = entry.value
			end
		end

		return {
			bufnr = entry.bufnr,
			filename = from_entry.path(entry, false, false),
			lnum = vim.F.if_nil(entry.lnum, 1),
			col = vim.F.if_nil(entry.col, 1),
			text = text,
		}
	end

	-- DEV: copied from telescope codebase
	local send_all_to_qf = function(prompt_bufnr, mode, target)
		local picker = action_state.get_current_picker(prompt_bufnr)
		local manager = picker.manager

		local qf_entries = {}
		for entry in manager:iter() do
			table.insert(qf_entries, entry_to_qf(entry))
		end

		local prompt = picker:_get_prompt()
		actions.close(prompt_bufnr)

		if target == "loclist" then
			vim.fn.setloclist(picker.original_win_id, qf_entries, mode)
		else
			vim.fn.setqflist(qf_entries, mode)
			local qf_title = string.format([[%s (%s)]], picker.prompt_title, prompt)
			vim.fn.setqflist({}, "a", { title = qf_title })
		end
	end

	send_all_to_qf(prompt_bufnr, " ")
	vim.cmd("copen")

	-- "cdo s/*/*/gc"
end

require("telescope").setup({
  file_ignore_patterns = {
    "node_modules",
    "vendor",
    ".git",
    "bin",
    "build",
    "dist",
  },
  defaults = {
    -- `hidden = true` is not supported in text grep commands.
    -- vimgrep_arguments = vimgrep_arguments,

    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      n = {
        ["<c-d>"] = require("telescope.actions").delete_buffer,
      }, -- n
      i = {
        ["<C-h>"] = "which_key",
        ["<c-d>"] = require("telescope.actions").delete_buffer,
        ["<C-r>"] = search_replace,
        ["<C-p>"] = false, -- disable movement
        ["<C-n>"] = false, -- disable movement
        ["<C-j>"] = actions.move_selection_next, -- move down
        ["<C-k>"] = actions.move_selection_previous, -- move up
        ["<C-o>"] = actions.select_default, -- enter
      },
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--ignore-file",
      ".gitignore",
    },
  },
})
require("telescope").load_extension("live_grep_args")
