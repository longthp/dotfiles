return {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    version = "*",
    config = function()
        require("toggleterm").setup({
            open_mapping = [[<c-\\>]],
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "float",
            close_on_exit = true,
            shell = "pwsh.exe", 
            auto_scroll = false,
            float_opts = {
                border = "curved",
                width = math.ceil(vim.o.columns*0.8),
                height = math.ceil(vim.o.columns*0.2),
                winblend = 0,
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
            },
        })

        local Terminal  = require('toggleterm.terminal').Terminal
        local lf = Terminal:new({
            cmd = "lf",
            hidden = true,
            direction = "float"
        })

        local lazygit = Terminal:new({
            cmd = "lazygit",
            hidden = true,
            direction = "float"
        })

        function _lf_toggle() lf:toggle() end
        function _lazygit_toggle() lazygit:toggle() end

        vim.api.nvim_set_keymap("n", "<leader>fl", "<cmd>lua _lf_toggle()<CR>", {noremap = true, silent = true})
        vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
    end,
}
