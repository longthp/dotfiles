return {
    "EdenEast/nightfox.nvim",
    event = "VimEnter",
    config = function()
        local colors = require('nightfox.palette').load("carbonfox")
        -- local colors = {
        --     rosewater = "#ff8389",
        --     flamingo = "#ff8389",
        --     red = "#ff8389",
        --     maroon = "#ff8389",
        --     pink = "#ff7eb6",
        --     mauve = "#be95ff",
        --     peach = "#d44a1c",
        --     yellow = "#ab8600",
        --     green = "#08bdba",
        --     teal = "#33b1ff",
        --     sky = "#33b1ff",
        --     sapphire = "#33b1ff",
        --     blue = "#78a9ff",
        --     lavender = "#78a9ff",
        --     text = "#ffffff",
        --     subtext1 = "#f4f4f4",
        --     subtext0 = "#e0e0e0",
        --     overlay2 = "#adadad",
        --     overlay1 = "#949494",
        --     overlay0 = "#7a7a7a",
        --     surface2 = "#4f4f4f",
        --     surface1 = "#383838",
        --     surface0 = "#2e2e2e",
        --     base = "#161616",
        --     mantle = "#0d0d0d",
        --     crust = "#000000",
        -- }
        require("nightfox").setup({
            options = {
                terminal_colors = true,
                transparent = true,
                styles = {
                },
            },
            groups = {
                all = {
                    -- GitSignsChange = { fg = colors.peach },
                    -- LineNr = { fg = colors.surface1 },
                    LineNr = { fg = colors.black },
                    IndentBlanklineChar = { fg = colors.black.dim },
                    IndentBlanklineContextChar = { fg = colors.black.dim },
                },
            },
        })

        vim.cmd [[colorscheme carbonfox]]
    end,
}
