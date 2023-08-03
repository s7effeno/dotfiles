return {
	"L3MON4D3/LuaSnip",
	dependencies = "rafamadriz/friendly-snippets",
	version = "2.*",
	build = "make install_jsregexp",
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load()
	end,
	lazy = true,
}
