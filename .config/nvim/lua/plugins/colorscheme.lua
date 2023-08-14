return {
    "Mofiqul/vscode.nvim",
    event = "VimEnter",
    config = function()
        local colors = require('vscode.colors').get_colors()
        require('vscode').setup({
            transparent = true
        })

        vim.cmd [[colorscheme vscode]]
    end
}
