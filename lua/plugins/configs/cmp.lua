local lsp = require("lsp-zero")
local cmp = require("cmp")

local cmp_status_ok, _ = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

require("luasnip.loaders.from_vscode").lazy_load()

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
	["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
	["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
	["<C-y>"] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
	["<Tab>"] = cmp.mapping(function(fallback)
		-- local copilot_keys = vim.fn["copilot#Accept"]()
		if cmp.visible() then
			cmp.select_next_item()
		elseif luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		-- elseif copilot_keys ~= "" and type(copilot_keys) == "string" then
		-- 	vim.api.nvim_feedkeys(copilot_keys, "i", true)
		else
			fallback()
		end
	end, {
		"i",
		"s",
	}),
})

cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

-- lsp.setup_nvim_cmp({
cmp.setup({
	sources = {
		-- { name = "copilot",  group_index = 2 },
		{ name = "path", group_index = 2 },
		{ name = "nvim_lsp", group_index = 2 },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
		{ name = "buffer", group_index = 3, keyword_length = 3 },
		-- { name = "buffer",   keyword_length = 3 },
		-- { name = "luasnip",  keyword_length = 2, group_index = 2 },
	},
	mapping = cmp_mappings,
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
})

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})
