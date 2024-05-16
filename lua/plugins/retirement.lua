-- closes buffers when they have been inactive for a long time
return {
	{
		"chrisgrieser/nvim-early-retirement",
		config = function()
			local retire = require("early-retirement")

			retire.setup({
				retirementAgeMins = 5,
			})
		end,
	},
}
