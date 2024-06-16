-- REF: https://andrewcourter.substack.com/p/configure-neovim-for-java-development
local home = os.getenv("HOME")
local lspcmd = home .. "/.local/share/nvim/mason/bin/jdtls"

local config = {
	cmd = { lspcmd },
	root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
}

return {
	"mfussenegger/nvim-jdtls",
	enabled = false,
	config = function()
		require("jdtls").start_or_attach(config)
	end,
}
