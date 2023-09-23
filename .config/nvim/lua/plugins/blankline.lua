return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("indent_blankline").setup {
            char = "┆",
            buftype_exclude = { "terminal", "nofile", "quickfix", "prompt", },
            filetype_exclude = { "NvimTree", "dashboard", "lazy", "telescope" },
        }
    end,
}
