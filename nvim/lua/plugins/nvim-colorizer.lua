return {
	"catgoose/nvim-colorizer.lua",
	event = "VeryLazy",
	config = function()
		require("colorizer").setup()
	end,
}
