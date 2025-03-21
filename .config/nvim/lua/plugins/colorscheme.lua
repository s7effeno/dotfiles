return {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
        require("gruvbox").setup({})

        vim.keymap.set("n", "<leader>l", function()
            vim.o.background = vim.o.background == "dark" and "light" or "dark"
        end, {
            desc = "Toggle light/dark theme",
        })

        vim.cmd([[colorscheme gruvbox]])
    end,
}
