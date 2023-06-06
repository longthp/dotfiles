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
