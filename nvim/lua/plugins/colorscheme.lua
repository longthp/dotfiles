return {
    "catppuccin/nvim",
    event = "VimEnter",
    name = "catppuccin",
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            background = {
                dark = "mocha",
            },
            term_colors = true,
            styles = {
                comments = { "italic" },
            },
            no_italic = true,
            transparent_background = false,
            show_end_of_buffer = false,
            color_overrides = {
                mocha = {
                    base = "#000000",
                    mantle = "#010101",
                    crust = "#020202",
                }
            },
            highlight_overrides = {
                all = function(colors)
                    local base_overrides = {
                        NormalFloat = { bg = colors.base },
                        FloatBorder = { bg = colors.base, fg = colors.surface0 },
                        LspInfoBorder = { link = "FloatBorder" },
                        NullLsInfoBorder = { link = "FloatBorder" },
                        VertSplit = { bg = colors.base, fg = colors.surface0 },
                        CursorLineNr = { fg = colors.mauve, style = { "bold" } },
                        Pmenu = { bg = colors.mantle, fg = "" },
                        PmenuSel = { bg = colors.surface0, fg = "" },
                        -- TelescopeSelection = { bg = colors.surface0 },
                        -- TelescopePromptCounter = { fg = colors.mauve, style = { "bold" } },
                        -- TelescopePromptPrefix = { bg = colors.surface0 },
                        -- TelescopePromptNormal = { bg = colors.surface0 },
                        -- TelescopeResultsNormal = { bg = colors.mantle },
                        -- TelescopePreviewNormal = { bg = colors.crust },
                        -- TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
                        -- TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
                        -- TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
                        -- TelescopePromptTitle = { fg = colors.surface0, bg = colors.surface0 },
                        -- TelescopeResultsTitle = { fg = colors.mantle, bg = colors.mantle },
                        -- TelescopePreviewTitle = { fg = colors.crust, bg = colors.crust },
                        GitSignsChange = { fg = colors.peach },
                        WhichKeyFloat = { bg = colors.mantle },
                        LineNr = { fg = colors.surface1 },
                        IndentBlanklineChar = { fg = colors.surface0 },
                        IndentBlanklineContextChar = { fg = colors.surface2 },
                        NeoTreeNormal = { bg = colors.mantle },
                        NeoTreeRootName = { fg = colors.blue, style = { "bold" } },
                        NeoTreeNormalNC = { bg = colors.mantle },
                        NeoTreeFloatBorder = { link = "TelescopeResultsBorder" },
                        NeoTreeTabActive = { fg = colors.text, bg = colors.mantle },
                        NeoTreeTabSeparatorActive = { fg = colors.mantle, bg = colors.mantle },
                        NeoTreeTabInactive = { fg = colors.surface2, bg = colors.crust },
                        NeoTreeTabSeparatorInactive = { fg = colors.crust, bg = colors.crust },
                        NeoTreeWinSeparator = { fg = colors.base, bg = colors.base },
                        NeoTreeGitConflict = { fg = colors.red },
                        NeoTreeGitDeleted = { fg = colors.red },
                        NeoTreeGitIgnored = { fg = colors.overlay0 },
                        NeoTreeGitModified = { fg = colors.peach },
                        NeoTreeGitUnstaged = { fg = colors.red },
                        NeoTreeGitUntracked = { fg = colors.blue },
                        NeoTreeGitStaged = { fg = colors.green },
                    }
                    return base_overrides
                end,
            },
            integrations = {
                treesitter = true,
                cmp = true,
                gitsigns = true,
                bufferline = true,
                indent_blankline = {
                    enabled = true,
                    colored_indent_levels = false,
                },
                mason = true,
                nvimtree = true,
                telescope = true,
            },
        })
        vim.cmd [[colorscheme catppuccin]]
    end,
}
