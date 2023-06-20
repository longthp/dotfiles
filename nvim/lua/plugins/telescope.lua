return {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    version = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "nvim-telescope/telescope-file-browser.nvim" },
    },
    config = function()
        local telescope = require("telescope")
        local fb_actions = require("telescope").extensions.file_browser.actions
        telescope.setup({
            defaults = {
                -- prompt_prefix = " ",
                -- selection_caret = " ",
                prompt_prefix = "     ",
                selection_caret = "  ",
                entry_prefix = "  ",
                layout_strategy = "horizontal",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                winblend = 0,
                color_devicons = true,
                use_less = true,
                mappings = {
                    i = {
                        ["<Tab>"] = "move_selection_next",
                        ["<S-Tab>"] = "move_selection_previous",
                        ["<C-s>"] = "select_horizontal",
                        ["<C-x>"] = "select_vertical",
                    },
                    n = {
                        ["<Tab>"] = "move_selection_next",
                        ["<S-Tab>"] = "move_selection_previous",
                        ["<C-w>"] = "delete_buffer",
                        ["q"] = "close",
                    },
                }
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                file_browser = {
                    theme = "dropdown",
                    hijack_netrw = true,
                    mappings = {
                        ["i"] = {
                            ["<C-w>"] = function() vim.cmd("normal vbd") end,
                        },
                        ["n"] = {
                            ["N"] = fb_actions.create,
                            ["D"] = fb_actions.remove,
                            ["R"] = fb_actions.rename,
                            ["C"] = fb_actions.copy,
                            ["h"] = fb_actions.goto_parent_dir,
                            ["/"] = function() vim.cmd("startinsert") end,
                        },
                    },
                },
            },
        })

        telescope.load_extension("fzf")
        telescope.load_extension("file_browser")

        -- local colors = require("catppuccin.palettes").get_palette()
        -- local TelescopeColor = {
        --     TelescopeMatching = { fg = colors.blue },
        --     TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },
        --
        --     TelescopePromptPrefix = { bg = colors.mantle },
        --     TelescopePromptNormal = { bg = colors.mantle },
        --     TelescopePromptBorder = { bg = colors.mantle, fg = colors.surface0 },
        --
        --     TelescopeResultsNormal = { bg = colors.mantle },
        --     TelescopeResultsBorder = { bg = colors.mantle, fg = colors.surface0 },
        --
        --     TelescopePreviewNormal = { bg = colors.mantle },
        --     TelescopePreviewBorder = { bg = colors.mantle, fg = colors.surface0 },
        --
        --     -- TelescopePromptTitle = { bg = colors.pink, fg = colors.mantle },
        --     TelescopeResultsTitle = { fg = colors.mantle },
        --     -- TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle },
        -- }
        --
        -- for hl, col in pairs(TelescopeColor) do
        --     vim.api.nvim_set_hl(0, hl, col)
        -- end
    end,
}
