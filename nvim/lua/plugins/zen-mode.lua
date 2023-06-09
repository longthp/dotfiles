return {
    "folke/zen-mode.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<leader>z",
            function()
                require("zen-mode").toggle()
            end,
            desc = "[ZenMode] Toggle",
        },
    },
    config = function()
        require("zen-mode").setup({
            window = {
                backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
                -- height and width can be:
                -- * an absolute number of cells when > 1
                -- * a percentage of the width / height of the editor when <= 1
                -- * a function that returns the width or the height
                width = 120, -- width of the Zen window
                height = 1, -- height of the Zen window
                options = {
                    -- signcolumn = "no", -- disable signcolumn
                    -- number = false, -- disable number column
                    -- relativenumber = false, -- disable relative numbers
                    -- cursorline = false, -- disable cursorline
                    -- cursorcolumn = false, -- disable cursor column
                    -- foldcolumn = "0", -- disable fold column
                    -- list = false, -- disable whitespace characters
                },
            },
            plugins = {
                options = {
                    enabled = true,
                    ruler = false, -- disables the ruler text in the cmd line area
                    showcmd = false, -- disables the command in the last line of the screen
                },
                twilight = { enabled = false },
                gitsigns = { enabled = false },
                tmux = { enabled = false },
                kitty = { enabled = false },
                alacritty = { enabled = false },
                wezterm = { enabled = false },
            },
            -- callback where you can add custom code when the Zen window opens
            on_open = function(win)
            end,
            -- callback where you can add custom code when the Zen window closes
            on_close = function()
            end,
        })
    end,
}
