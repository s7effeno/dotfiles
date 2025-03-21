return {
    "L3MON4D3/LuaSnip",
    dependencies = "rafamadriz/friendly-snippets",
    version = "2.*",
    build = "make install_jsregexp",
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        local luasnip = require("luasnip");
        vim.keymap.set({ "i", "s" }, "<C-L>", function() luasnip.jump(1) end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-H>", function() luasnip.jump(-1) end, { silent = true })
    end,
    lazy = true,
}
