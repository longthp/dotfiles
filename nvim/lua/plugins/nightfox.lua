return {
    "EdenEast/nightfox.nvim",
    event = "VimEnter",
    config = function()
        require("nightfox").setup({
            options = {
                terminal_colors = true,
                transparent = false,
                styles = {
                },
            },
        })
        vim.cmd [[colorscheme carbonfox]]
    end,
}
