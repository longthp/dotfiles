return {
    "nvim-tree/nvim-tree.lua",
    cmd = "NvimTreeToggle",
    keys = {
        {
            "<C-n>",
            function()
                require("nvim-tree.api").tree.toggle()
            end,
            desc = "[NVIMTREE] Toggle",
        },
    },
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        auto_reload_on_write = true,
        disable_netrw = false,
        hijack_cursor = false,
        hijack_netrw = true,
        hijack_unnamed_buffer_when_opening = false,
        open_on_tab = false,
        sort_by = "name",
        update_cwd = true,
        reload_on_bufenter = true,
        respect_buf_cwd = false,
        view = {
            adaptive_size = true,
            width = 32,
            hide_root_folder = false,
            side = "left",
            preserve_window_proportions = false,
            number = false,
            relativenumber = false,
            signcolumn = "yes",
        },
        on_attach = function(bufnr)
            local api = require("nvim-tree.api")

            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end
            api.config.mappings.default_on_attach(bufnr)
            vim.keymap.set("n", "D", api.fs.remove, opts("Delete"))
            vim.keymap.set("n", "d", api.fs.trash, opts("Trash"))
        end,
        renderer = {
            add_trailing = false,
            group_empty = false,
            highlight_git = true,
            highlight_modified = "none",
            highlight_opened_files = "none",
            root_folder_label = function(path)
                return (vim.g.emoji and "🗃 " or " ") .. vim.fn.fnamemodify(path, ":t")
            end,
            indent_markers = {
                enable = true,
                icons = {
                    corner = "└",
                    edge = "│",
                    none = "",
                },
            },
            icons = {
                webdev_colors = true,
                git_placement = "after",
                padding = " ",
                symlink_arrow = "  ",
                modified_placement = "after",
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = true,
                    modified = true,
                },
                glyphs = {
                    default = "󰈙",
                    symlink = "󰈝",
                    modified = "●",
                    folder = {
                        arrow_closed = "",
                        arrow_open = "",
                        default = "󰉋",
                        empty = "󰉋",
                        empty_open = "󰉋",
                        open = "󰉋",
                        symlink = "󰉒",
                        symlink_open = "󰉒",
                    },
                    git = {
                        unstaged = "",
                        staged = "",
                        unmerged = "",
                        renamed = "",
                        untracked = "",
                        deleted = "",
                        ignored = "",
                    },
                },
            },
            special_files = { "package.json", "README.md", "readme.md", "Cargo.toml" },
        },
        hijack_directories = {
            enable = true,
            auto_open = true,
        },
        update_focused_file = {
            enable = true,
            update_cwd = true,
            ignore_list = {},
        },
        system_open = {
            cmd = "",
            args = {},
        },
        diagnostics = {
            enable = false,
            show_on_dirs = false,
            icons = {
                error = "▏",
                hint = "▏",
                info = "▏",
                warning = "▏",
            },
        },
        filters = {
            dotfiles = false,
            custom = {
                "^.git$",
            },
            exclude = {},
        },
        git = {
            enable = true,
            ignore = false,
            timeout = 400,
        },
        modified = {
            enable = true,
            show_on_dirs = true,
            show_on_open_dirs = true,
        },
        actions = {
            use_system_clipboard = true,
            change_dir = {
                enable = true,
                global = false,
                restrict_above_cwd = false,
            },
            open_file = {
                quit_on_open = false,
                resize_window = true,
                window_picker = {
                    enable = true,
                    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                    exclude = {
                        filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                        buftype = { "nofile", "terminal", "help" },
                    },
                },
            },
            remove_file = {
                close_window = false,
            }
        },
        trash = {
            cmd = "trash",
            require_confirm = true,
        },
        live_filter = {
            prefix = "[FILTER]: ",
            always_show_folders = true,
        },
    },
}
