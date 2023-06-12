return {
    'VonHeikemen/lsp-zero.nvim',
    event = { "BufReadPre", "BufNewFile" },
    branch = 'v2.x',
    dependencies = {
        {'neovim/nvim-lspconfig'},
        {
            'williamboman/mason.nvim',
            build = function()
                pcall(vim.cmd, 'MasonUpdate')
            end,
        },
        {'williamboman/mason-lspconfig.nvim'},

        {'L3MON4D3/LuaSnip'},
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-nvim-lsp'},
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
            -- "pyright",
            "pylsp",
            "dockerls",
            "docker_compose_language_service",
            "sqlls",
            "yamlls",
            "marksman",
            "lemminx",
        })

        require("lspconfig").pylsp.setup({
            settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = {
                            ignore = { "F401", "E302", "E305", "E133", "E203", "W503" },
                            maxLineLength = 100,
                        },
                    },
                },
            },
        })

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
            mapping = {
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                ["<C-e>"] = cmp.mapping.abort(), -- close completion window
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif vim.fn["vsnip#available"](1) == 1 then
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-next)", true, true, true), "", true)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, true, true), "", true)
                    end
                end, { "i", "s" }),
            },
            sources = {
                { name = "path" },
                { name = "nvim_lsp" },
                { name = "vsnip" },
                { name = "buffer" },
            },
            preselect = cmp.PreselectMode.None,
        })

        local mason = require("mason")

        mason.setup({
            ui = {
                icons = {
                    package_pending = " ",
                    package_installed = "󰄳 ",
                    package_uninstalled = " 󰚌",
                },
                border = "single",
                keymaps = {
                    toggle_server_expand = "<CR>",
                    install_server = "i",
                    update_server = "u",
                    check_server_version = "c",
                    update_all_servers = "U",
                    check_outdated_servers = "C",
                    uninstall_server = "X",
                    cancel_installation = "<C-c>",
                },
            },

            max_concurrent_installers = 10,
        })
    end,
}
