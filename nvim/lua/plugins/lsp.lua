return {
    'VonHeikemen/lsp-zero.nvim',
    event = { "BufReadPre", "BufNewFile" },
    branch = 'v2.x',
    dependencies = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},             -- Required
        {                                      -- Optional
            'williamboman/mason.nvim',
            build = function()
                pcall(vim.cmd, 'MasonUpdate')
            end,
        },
        {'williamboman/mason-lspconfig.nvim'}, -- Optional

        -- Autocompletion
        {'L3MON4D3/LuaSnip'},     -- Required
        {'hrsh7th/nvim-cmp'},     -- Required
        {'hrsh7th/cmp-nvim-lsp'}, -- Required
        {"hrsh7th/cmp-cmdline"},
        {"hrsh7th/cmp-buffer"},
        {"hrsh7th/cmp-path"},
        {
            "hrsh7th/vim-vsnip",
            dependencies = {
                "rafamadriz/friendly-snippets",
            },
        },
    },
    config = function()
        local lsp = require('lsp-zero').preset({})

        lsp.on_attach(function(client, bufnr)
            lsp.default_keymaps({
                buffer = bufnr,
                preserve_mappings = true,
            })
        end)

        lsp.ensure_installed({
            "pyright",
            "dockerls",
            "sqlls",
            "yamlls",
            "marksman",
        })
        -- lsp.setup_servers({
        --     "pyright",
        --     "dockerls",
        --     "sqlls",
        --     "yamlls",
        -- })

        lsp.setup()
        

        local cmp = require("cmp")

        local kinds = {
            Class = "",
            Color = "",
            Constant = "",
            Constructor = "",
            Enum = "",
            EnumMember = "",
            Event = "",
            Field = "",
            File = "󰈙",
            Folder = "󰉋",
            Function = "",
            Interface = "",
            Keyword = "",
            Method = "",
            Module = "",
            Operator = "",
            Property = "",
            Reference = "",
            Snippet = "",
            Struct = "",
            Text = "",
            TypeParameter = "",
            Unit = "",
            Value = "",
            Variable = "",
        }

        cmp.setup({
            window = {
                completion = {
                    col_offset = -3,
                    side_padding = 0,
                },
                documentation = {
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                },
            },
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(_, vim_item)
                    vim_item.menu = vim_item.kind
                    vim_item.kind = string.format(" %s ", kinds[vim_item.kind])

                    return vim_item
                end,
            },
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                ["<C-e>"] = cmp.mapping.abort(), -- close completion window
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
            }),
            sources = {
                { name = "path" },
                { name = "nvim_lsp" },
                { name = "vsnip" },
                { name = "buffer" },
            },
            preselect = cmp.PreselectMode.None,
        })

    end,
}
