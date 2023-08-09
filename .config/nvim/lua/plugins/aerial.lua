return {
    'stevearc/aerial.nvim',
    event = "VeryLazy",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    keys = {
        {
            "<leader>a",
            "<CMD>AerialToggle!<CR>",
            desc = "[Aerial] Toggle",
        },
        {
            "<leader>n",
            "<CMD>AerialNavToggle<CR>",
            desc = "[Aerial] NavToggle",
        },
    },
    config = function()
        require("aerial").setup({
            backends = { "treesitter", "lsp", "markdown", "man" },
            layout = {
                default_direction = "prefer_right",
                placement = "window",
                resize_to_content = true,
            },
            keymaps = {

            },
            float = {
                border = "single",
                relative = "editor",

            },
        })
    end,
}
