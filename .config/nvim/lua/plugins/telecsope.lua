return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>sf", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Find Files" },
		{ "<leader>sp", "<cmd>lua require('telescope.builtin').git_files()<cr>", desc = "Find Git Files" },
		{ "<leader>sg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "Live Grep" },
	},
}
