local colors = {
	darkgray = "#16161d",
	gray = "#727169",
	outerbg = "#16161D",
	normal = "#7e9cd8",
	insert = "#98bb6c",
	visual = "#ffa066",
	replace = "#e46876",
	command = "#e6c384",
}

local function count_items(qf_list)
	if #qf_list > 0 then
		local valid = 0
		for _, item in ipairs(qf_list) do
			if item.valid == 1 then
				valid = valid + 1
			end
		end
		if valid > 0 then
			return tostring(valid)
		end
	end
end

local function lualine_theme()
	return {
		inactive = {
			a = { fg = colors.visual, bg = colors.outerbg, gui = "bold" },
			c = { fg = colors.darkergray, bg = nil },
		},
		visual = {
			a = { fg = colors.visual, bg = colors.outerbg, gui = "bold" },
			c = { fg = colors.darkergray, bg = nil },
		},
		replace = {
			a = { fg = colors.replace, bg = colors.outerbg, gui = "bold" },
			c = { fg = colors.darkergray, bg = nil },
		},
		normal = {
			a = { fg = colors.normal, bg = nil, gui = "bold" },
			c = { fg = colors.darkergray, bg = nil },
		},
		insert = {
			a = { fg = colors.insert, bg = colors.outerbg, gui = "bold" },
			c = { fg = colors.darkergray, bg = nil },
		},
		command = {
			a = { fg = colors.command, bg = colors.outerbg, gui = "bold" },
			c = { fg = colors.darkergray, bg = nil },
		},
	}
end

local lualineConfig = {
	options = {
		icons_enabled = false,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		theme = lualine_theme(),
	},
	sections = {
		-- lualine_b = {},
		-- lualine_c = {
		--   {
		--     'filename',
		--     file_status = true,
		--     path = 1
		--   }
		-- }
		lualine_a = { "mode" },
		lualine_b = {},
		-- lualine_b = { 'diff', 'filename' },
		lualine_c = {
			--'filename'
			{
				"buffers",
				buffers_color = {
					"buffers",
					active = { bg = nil, fg = colors.darkergray },
					inactive = { bg = nil, fg = colors.gray },
				},
			},
		},
		lualine_x = { "filetype" }, -- {'encoding', 'fileformat', 'filetype'},
		lualine_y = {
			-- show how many trail whitespaces we have
			function()
				local space = vim.fn.search([[\s\+$]], "nwc")
				return space ~= 0 and "TW:" .. space or ""
			end,
			-- show how many mixed indent there is
			function()
				local space_pat = [[\v^ +]]
				local tab_pat = [[\v^\t+]]
				local space_indent = vim.fn.search(space_pat, "nwc")
				local tab_indent = vim.fn.search(tab_pat, "nwc")
				local mixed = (space_indent > 0 and tab_indent > 0)
				local mixed_same_line
				if not mixed then
					mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], "nwc")
					mixed = mixed_same_line > 0
				end
				if not mixed then
					return ""
				end
				if mixed_same_line ~= nil and mixed_same_line > 0 then
					return "MI:" .. mixed_same_line
				end
				local space_indent_cnt = vim.fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
				local tab_indent_cnt = vim.fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total
				if space_indent_cnt > tab_indent_cnt then
					return "MI:" .. tab_indent
				else
					return "MI:" .. space_indent
				end
			end,
			-- show lsp progress
			-- function()
			--   local messages = vim.lsp.util.get_progress_messages()
			--   if #messages == 0 then
			--     return ""
			--   end
			--   local status = {}
			--   for _, msg in pairs(messages) do
			--     table.insert(status, (msg.percentage or 0) .. "%% " .. (msg.title or ""))
			--   end
			--   local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
			--   local ms = vim.loop.hrtime() / 1000000
			--   local frame = math.floor(ms / 120) % #spinners
			--   return table.concat(status, " | ") .. " " .. spinners[frame + 1]
			-- end,
			-- quicklist/loclist count
			{
				function()
					local loc_values = vim.fn.getloclist(vim.api.nvim_get_current_win())
					local items = count_items(loc_values)
					if items then
						return "Loc: " .. items
					end
					return ""
				end,
				on_click = function(clicks, button, modifiers)
					local winid = vim.fn.getqflist(vim.api.nvim_get_current_win(), { winid = 0 }).winid
					if winid == 0 then
						vim.cmd.lopen()
					else
						vim.cmd.lclose()
					end
				end,
			},
			{
				function()
					local qf_values = vim.fn.getqflist()
					local items = count_items(qf_values)
					if items then
						return "Qf: " .. items
					end
					return ""
				end,
				on_click = function(clicks, button, modifiers)
					local winid = vim.fn.getqflist({ winid = 0 }).winid
					if winid == 0 then
						vim.cmd.copen()
					else
						vim.cmd.cclose()
					end
				end,
			},
		}, -- {'progress'},
		lualine_z = {
			-- word / character count
			function()
				local wc = vim.fn.wordcount()
				if wc["visual_words"] then -- text is selected in visual mode
					return wc["visual_words"] .. "W/" .. wc["visual_chars"] .. "C"
				else -- all of the document
					-- return wc["words"] .. " Words"
					return ""
				end
			end,
			"location",
		},
	},
}

return {
	{
		-- line on bottom of vim more complete
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup(lualineConfig)
		end,
	},
}
