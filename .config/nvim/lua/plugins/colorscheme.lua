return {
    "Mofiqul/vscode.nvim",
    event = "VimEnter",
    config = function()
        local colors = require('vscode.colors').get_colors()
        require('vscode').setup({
            transparent = true,
            group_overrides = {
                LazyNormal = {
                    bg = "#161616"
                }
            },
        })

        vim.cmd [[colorscheme vscode]]
    end
}
