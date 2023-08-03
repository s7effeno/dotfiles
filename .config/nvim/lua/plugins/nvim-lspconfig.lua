return {
	"neovim/nvim-lspconfig",
	config = function()
		vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
		vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist)
	end,
    lazy = true,
}
