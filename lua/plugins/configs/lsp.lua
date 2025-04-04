local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")
local util = require("lspconfig/util")
local cmp = require("cmp")
local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

local cmp_status_ok, _ = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

lsp.preset("recommended")
-- lsp.ensure_installed({
-- "lua_ls",
-- "jsonls",
-- "dockerls",
-- "bashls",
-- "html",
-- "cssls",
-- "gopls",
-- "sqlls",
-- "eslint",
-- })

-- Fix Undefined global 'vim'
-- lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

-- Fix Undefined global 'vim'
-- lsp.configure('lua-language-server', {
--     settings = {
--         Lua = {
--             diagnostics = {
--                 globals = { 'vim' }
--             }
--         }
--     }
-- })

lspconfig.ts_ls.setup({
  root_dir = util.root_pattern("package.json", "tsconfig.json", ".git"),
  capabilities = default_capabilities,
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  settings = {
    maxTsServerMemory = 4096,
  },
  flags = {
    debounce_text_changes = 1000,
  },
})

lspconfig.eslint.setup({
  root_dir = util.root_pattern("package.json", "tsconfig.json"),
  capabilities = default_capabilities,
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	settings = {
    codeActionOnSave = {
      enable = false,
      mode = "all"
    },
    onIgnoredFiles = "off",
    run = "onSave",
		workingDirectory = {
			mode = "auto",
      -- mode = "local",
		},
		format = { enable = true },
		lint = { enable = true },
	},
  flags = {
    allow_incremental_sync = false,
    debounce_text_changes = 1000,
  }
})

-- lspconfig.gopls.setup({
-- 	-- cmd = { "gopls", "-remote=auto", "-remote.listen.timeout=5m", "serve" },
-- 	-- cmd = { "gopls", "serve" },
-- 	cmd = { "gopls" },
-- 	filetypes = { "go", "gomod", "gowork", "gotmpl" },
-- 	root_dir = util.root_pattern("go.work", "go.mod", ".git"),
-- 	capabilities = require("cmp_nvim_lsp").default_capabilities(),
-- 	settings = {
-- 		gopls = {
-- 			completeUnimported = true,
-- 			usePlaceholders = true,
-- 			analyses = {
-- 				unusedparams = true,
-- 				assign = true,
-- 				bools = true,
-- 			},
-- 			-- env = {
-- 			-- GOOS = "js",
-- 			-- GOARCH = "wasm",
-- 			-- },
-- 			--
-- 			staticcheck = true,
-- 			linksInHover = false,
-- 			codelenses = {
-- 				generate = true,
-- 				gc_details = true,
-- 				regenerate_cgo = true,
-- 				tidy = true,
-- 				upgrade_depdendency = true,
-- 				vendor = true,
-- 			},
-- 		},
-- 	},
-- })

-- lspconfig.sqlls.setup({
-- 	capabilities = require("cmp_nvim_lsp").default_capabilities(),
-- 	filetypes = { "sql" },
-- 	root_dir = function(_)
-- 		return vim.loop.cwd()
-- 	end,
-- })

-- lspconfig.zls.setup({})

-- lspconfig.rust_analyzer.setup({
--   -- on_attach = on_attach,
--   capabilities = require("cmp_nvim_lsp").default_capabilities(),
--   filetypes = { "rust" },
--   root_dir = util.root_pattern("Cargo.toml"),
--   settings = {
--     ['rust-analyzer'] = {
--       cargo = {
--         allFeatures = true,
--       },
--     }
--   }
-- })

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

lsp.set_preferences({
	suggest_lsp_servers = false,
	sign_icons = {
		error = "E",
		warn = "W",
		hint = "H",
		info = "I",
	},
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "<leader>gd", function()
		vim.lsp.buf.definition()
	end, opts)

	vim.keymap.set("n", "K", function()
		local filetype = vim.bo.filetype
		if filetype == "rust" then
			vim.cmd.RustLsp({ "hover", "actions" })
		else
			vim.lsp.buf.hover()
		end
	end, opts)
	vim.keymap.set("n", "<leader>vws", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set("n", "<leader>vd", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set("n", "<leader>vca", function()
		vim.lsp.buf.code_action()
	end, opts)
	-- vim.keymap.set("n", "<leader>vrr", function()
	-- 	vim.lsp.buf.references()
	-- end, opts)
	-- vim.keymap.set("n", "<leader>vrn", function()
	-- 	vim.lsp.buf.rename()
	-- end, opts)
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
end)

lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
})

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  return hover({
    border = "single",
    -- border = border,
    -- max_width = 100,
    max_width = math.floor(vim.o.columns * 0.9),
    max_height = math.floor(vim.o.lines * 0.9),
  })
end
