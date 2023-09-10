return {
    -- "neanias/everforest-nvim",
    -- "Mofiqul/vscode.nvim",
    "rebelot/kanagawa.nvim",
    event = "VimEnter",
    config = function()
        -- local colors = require('vscode.colors').get_colors()
        -- require('vscode').setup({
        --     transparent = true,
        --     group_overrides = {
        --         LazyNormal = {
        --             bg = "#161616"
        --         }
        --     },
        -- })

        -- vim.cmd [[colorscheme vscode]]

        -- require("everforest").setup({
        --     background = "hard",
        --     transparent_background_level = 2,
        --     on_highlights = function(hl, palette)
        --         hl.LazyNormal = { bg = "#161616" }
        --     end
        -- })
        --
        -- vim.cmd [[colorscheme everforest]]

        require("kanagawa").setup({
            compile = false,
            theme = "wave",
            transparent = true,
            colors = {
                theme = {
                    all = {
                        ui = {
                            bg_gutter = "none"
                        }
                    }
                },
            },
            overrides = function(colors)
                local theme = colors.theme
                return {
                    TelescopeTitle = { fg = theme.ui.special, bold = true },
                    TelescopePromptBorder = { fg = theme.ui.bg_p1 },
                    TelescopeResultsBorder = { fg = theme.ui.bg_p1 },
                    TelescopePreviewBorder = { fg = theme.ui.bg_p1 },
                    NormalFloat = { bg = "none" },
                    FloatBorder = { bg = "none" },
                    FloatTitle = { bg = "none" },

                    -- Save an hlgroup with dark background and dimmed foreground
                    -- so that you can use it where your still want darker windows.
                    -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
                    NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

                    -- Popular plugins that open floats will link to NormalFloat by default;
                    -- set their background accordingly if you wish to keep them dark and borderless
                    LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                    MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

                    Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },  -- add `blend = vim.o.pumblend` to enable transparency
                    PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                    PmenuSbar = { bg = theme.ui.bg_m1 },
                    PmenuThumb = { bg = theme.ui.bg_p2 },
                }
            end,
        })
        vim.cmd [[colorscheme kanagawa]]
    end
}
