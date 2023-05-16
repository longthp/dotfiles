return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        {
            "hrsh7th/vim-vsnip",
            dependencies = {
                "rafamadriz/friendly-snippets",
            },
        },
    },
    config = function()
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
            enabled = function()
                local in_prompt = vim.api.nvim_buf_get_option(0, "buftype") == "prompt"
                if in_prompt then
                    return false
                end
                local context = require("cmp.config.context")
                return not (context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment"))
            end,
            view = {
                entries = "custom",
            },
            completion = {
                completeopt = "longest,menuone",
                keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
                keyword_length = 1,
            },
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
                ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                ["<C-e>"] = cmp.mapping.abort(), -- close completion window
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
            },
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
