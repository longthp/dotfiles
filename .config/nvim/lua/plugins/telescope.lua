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
                prompt_prefix = "     ",
                selection_caret = "  ",
                entry_prefix = "  ",
                border = true,
                borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
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
            pickers = {
                find_files = {
                    hidden = true,
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
                    hijack_netrw = true,
                    hidden = {
                        file_browser = true,
                        folder_browser = true,
                    },
                    display_stat = false,
                    grouped = true,
                    previewer = true,
                    initial_browser = "tree",
                    auto_depth = true,
                    depth = 1,
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

    end,
}
