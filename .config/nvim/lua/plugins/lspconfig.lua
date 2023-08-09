return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            "jose-elias-alvarez/null-ls.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
        },
        "b0o/schemastore.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "rounded",
        })

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "rounded",
        })

        require("lspconfig.ui.windows").default_options = {
            border = "rounded",
        }

        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

        local on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ timeout = 5000, bufnr = bufnr })
                    end,
                })
            end
        end

        vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "[LSP] Next Diagnostic" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "[LSP] Previous Diagnostic" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "[LSP] Next Diagnostic" })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "[LSP] Goto Declaration" })
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "[LSP] Goto Definition" })
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "[LSP] Hover" })
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "[LSP] Goto Implementation" })
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "[LSP] Signature Help" })
                vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "[LSP] Show Type Definition" })
                vim.keymap.set("n", "<space>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "[LSP] Rename" })
                vim.keymap.set("n", "<space>lc", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "[LSP] Code Actions" })
                vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "[LSP] References" })
                vim.keymap.set("n", "<space>lf", function()
                    vim.lsp.buf.format({ timeout = 5000 })
                end, { buffer = ev.buf, desc = "[LSP] Format" })
            end,
        })

        local capabilities =
        vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities())
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        local servers = {
            -- "pyright",
        }

        for _, server in ipairs(servers) do
            local lspconfig = require("lspconfig")
            lspconfig.server.setup({
                on_attach = on_attach,
                capabilities = capabilities
            })
        end
    end,
}
