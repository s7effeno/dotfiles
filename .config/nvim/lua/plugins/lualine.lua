return {
	"nvim-lualine/lualine.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = true,
	opts = {
		theme = "gruvbox",
		sections = {
			lualine_c = {
				{
					"navic",
					color_correction = nil,
					navic_opts = nil,
				},
			},
		},
	},
}
