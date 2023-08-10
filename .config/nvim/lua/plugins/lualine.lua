return {   
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local conditions = {
            buffer_not_empty = function()
                return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
            end,

            hide_in_width = function()
                return vim.fn.winwidth(0) > 80
            end,

            check_git_workspace = function()
                local filepath = vim.fn.expand('%:p:h')
                local gitdir = vim.fn.finddir('.git', filepath .. ';')
                return gitdir and #gitdir > 0 and #gitdir < #filepath
            end,
        }
        local colors = {
            bg       = '#161616',
            fg       = '#bbc2cf',
            yellow   = '#ECBE7B',
            cyan     = '#008080',
            darkblue = '#081633',
            green    = '#42be65',
            orange   = '#FF8800',
            violet   = '#a9a1e1',
            magenta  = '#be95ff',
            blue     = '#33b1ff',
            red      = '#ee5396',
        }

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                section_separators = "",
                component_separators = "",
                disabled_filetypes = {
                    "TelescopePrompt",
                    "packer",
                },
            },
            sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    {
                        function()
                            return "▋"
                        end,
                        color = function()
                            -- auto change color according to neovims mode
                            local mode_color = {
                                n = colors.blue,
                                i = colors.green,
                                v = colors.magenta,
                                [''] = colors.blue,
                                V = colors.blue,
                                c = colors.magenta,
                                no = colors.red,
                                s = colors.orange,
                                S = colors.orange,
                                [''] = colors.orange,
                                ic = colors.yellow,
                                R = colors.violet,
                                Rv = colors.violet,
                                cv = colors.red,
                                ce = colors.red,
                                r = colors.cyan,
                                rm = colors.cyan,
                                ['r?'] = colors.cyan,
                                ['!'] = colors.red,
                                t = colors.red,
                            }
                            return { fg = mode_color[vim.fn.mode()] }
                        end,
                        padding = {
                            left = 0
                        }
                    },
                    -- {
                    --     'filetype',
                    --     colored = true,
                    --     icon_only = true,
                    --     padding = { left = 1, right = 0 },
                    -- },
                    {
                        "buffers",
                        show_filename_only = true,
                        hide_filename_extension = false,
                        show_modified_status = true,
                        mode = 2,
                        buffers_color = {
                            active = {
                                bg = colors.bg,
                            }
                        },
                        symbols = {
                            modified = " [+]",
                            alternate_file = "",
                            directory = "",
                        },
                        cond = conditions.buffer_not_empty,
                    },
                    -- {
                    --     'filename',
                    --     file_status = true,
                    --     icons_enabled = false,
                    --     path = 0,
                    --     symbols = {
                    --         modified = '[+]',
                    --         readonly = '[-]',
                    --         unnamed = '[No Name]',
                    --         newfile = '[New]',
                    --     }
                    -- },
                    {
                        function()
                            return (" %s "):format(vim.bo.filetype:upper())
                        end,
                        padding = { left = 0 },
                        cond = conditions.buffer_not_empty,
                    },
                    {
                        "filesize",
                        cond = conditions.buffer_not_empty,
                    },
                },
                lualine_x = {
                    {
                        function()
                            local msg = ''
                            local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                            local clients = vim.lsp.get_active_clients()
                            if next(clients) == nil then
                                return msg
                            end
                            for _, client in ipairs(clients) do
                                local filetypes = client.config.filetypes
                                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                                    return client.name
                                end
                            end
                            return msg
                        end,
                        icon = ' ',
                        cond = conditions.buffer_not_empty,
                    },
                    {
                        'diagnostics',
                        sources = { "nvim_diagnostic" },
                        symbols = {
                            error = " ",
                            warn = " ",
                            info = " ",
                            hint = " ",
                        }
                    },
                    {
                        "diff",
                        symbols = {
                            added = ' ',
                            removed = ' ',
                            modified = ' ',
                        },
                    },
                    {
                        'branch',
                        icon = { "" },
                        color = { fg = colors.magenta },
                    },
                },
                lualine_y = {},
                lualine_z = {},
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            extensions = {},
        })
    end,
}
