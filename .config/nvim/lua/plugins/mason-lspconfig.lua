return {
    "williamboman/mason-lspconfig",
    opts = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local on_attach = function(_, bufnr)
            local function opts(desc)
                return {
                    buffer = bufnr,
                    desc = desc
                }
            end
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts())
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts())
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts())
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts())
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts())
            vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts())
            vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts())
            vim.keymap.set("n", "<leader>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts())
            vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts())
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts())
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts())
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts())
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
            vim.keymap.set("n", "<leader>d", toggle_diagnostic, opts())
        end

        return {
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                end,
                ["lua_ls"] = function()
                    require("lspconfig")["lua_ls"].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" },
                                },
                            },
                        },
                    })
                end,
            },
        }
    end,
}
