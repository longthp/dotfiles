return {
    "catppuccin/nvim",
    event = "VimEnter",
    name = "catppuccin",
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            term_colors = true,
            styles = {
                comments = { "italic" },
            },
            no_italic = true,
            transparent_background = false,
            show_end_of_buffer = false,
        })
        vim.cmd.colorscheme "catppuccin"
    end,
}
