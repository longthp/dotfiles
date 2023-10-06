return {
    "ellisonleao/gruvbox.nvim",
    -- "rebelot/kanagawa.nvim",
    event = "VimEnter",
    config = function()
        -- require("kanagawa").setup({
        --     compile = false,
        --     theme = "wave",
        --     transparent = false,
        --     colors = {
        --         theme = {
        --             all = {
        --                 ui = {
        --                     bg = "#161616",
        --                     bg_gutter = "none",
        --                 }
        --             }
        --         },
        --     },
        --     overrides = function(colors)
        --         local theme = colors.theme
        --         return {
        --             TelescopeTitle = { fg = theme.ui.special, bold = true },
        --             TelescopePromptBorder = { fg = theme.ui.float.fg_border },
        --             TelescopeResultsBorder = { fg = theme.ui.float.fg_border },
        --             TelescopePreviewBorder = { fg = theme.ui.float.fg_border },
        --             NormalFloat = { bg = "none" },
        --             FloatBorder = { bg = "none" },
        --             FloatTitle = { bg = "none" },
        --
        --             NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
        --
        --             LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        --             MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        --
        --             Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
        --             PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
        --             PmenuSbar = { bg = theme.ui.bg_m1 },
        --             PmenuThumb = { bg = theme.ui.bg_p2 },
        --         }
        --     end,
        -- })
        -- vim.cmd [[colorscheme kanagawa]]
        require("gruvbox").setup({
            transparent_mode = false,
            palette_overrides = {
                dark0 = "#161616",
            },
            overrides = {
                SignColumn = { bg = "#161616" },
                LazyNormal = { bg = "#161616" },
                MasonNormal = { bg = "#161616" },
            }
        })
        vim.cmd [[colorscheme gruvbox]]
    end
}
