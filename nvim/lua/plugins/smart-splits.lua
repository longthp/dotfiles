return {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<leader><leader>h",
            function()
                require("smart-splits").swap_buf_left()
            end,
            desc = "Swap buffer Up"
        },
        {
            "<leader><leader>j",
            function()
                require("smart-splits").swap_buf_down()
            end,
            desc = "Swap buffer Up"
        },
        {
            "<leader><leader>k",
            function()
                require("smart-splits").swap_buf_up()
            end,
            desc = "Swap buffer Up"
        },
        {
            "<leader><leader>l",
            function()
                require("smart-splits").swap_buf_right()
            end,
            desc = "Swap buffer Up"
        },
        {
            "<C-h>",
            function()
                require("smart-splits").resize_left()
            end,
            desc = "Resize Left",
        },
        {
            "<C-l>",
            function()
                require("smart-splits").resize_right()
            end,
            desc = "Resize Right",
        },
        {
            "<C-k>",
            function()
                require("smart-splits").resize_up()
            end,
            desc = "Resize Up",
        },
        {
            "<C-j>",
            function()
                require("smart-splits").resize_down()
            end,
            desc = "Resize Down",
        },
    },
    config = true,
}
