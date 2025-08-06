return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    opts = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local on_attach = function(_, bufnr)
            local function opts(desc)
                return {
                    buffer = bufnr,
                    desc = desc
                }
            end
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover"))
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts("Signature help"))
            vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
            vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
            vim.keymap.set("n", "<leader>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders("List workspace folder")))
            end, opts())
            vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts("View type definition"))
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename"))
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("View references"))
            vim.keymap.set("n", "<leader>f", function()
                vim.lsp.buf.format({ async = true })
            end, opts("Format"))
            local diagnostic_enabled = true
            local function toggle_diagnostic()
                if diagnostic_enabled then
                    vim.diagnostic.disable()
                else
                    vim.diagnostic.enable()
                end
                diagnostic_enabled = not diagnostic_enabled
            end
            vim.keymap.set("n", "<leader>d", toggle_diagnostic, opts("Toggle diagnostics"))
        end

        vim.lsp.config("*", {
            on_attach = on_attach,
            capabilities = capabilities,
        })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },
        })
    end
}
