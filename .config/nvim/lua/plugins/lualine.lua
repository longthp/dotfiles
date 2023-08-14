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
        -- local colors = {
        --     bg       = '#161616',
        --     fg       = '#bbc2cf',
        --     yellow   = '#ECBE7B',
        --     cyan     = '#008080',
        --     darkblue = '#081633',
        --     green    = '#42be65',
        --     orange   = '#FF8800',
        --     violet   = '#a9a1e1',
        --     magenta  = '#be95ff',
        --     blue     = '#33b1ff',
        --     red      = '#ee5396',
        -- }

        local colors = {
            bg = "#161616",
            fg = "#bbc2cf",
            gray = '#808080',
            violet = '#646695',
            blue = '#569CD6',
            accent_blue = '#4FC1FE',
            dark_blue = '#223E55',
            medium_blue = '#18a2fe',
            light_blue = '#9CDCFE',
            green = '#6A9955',
            blue_green = '#4EC9B0',
            light_green = '#B5CEA8',
            red = '#F44747',
            light_red = '#D16969',
            orange = '#CE9178',
            yellow_orange = '#D7BA7D',
            yellow = '#DCDCAA',
            dark_yellow = '#FFD602',
            pink = '#C586C0',
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
                    "lazy",
                },
            },
            sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    {
                        function()
                            return "▋" .. vim.fn.mode()
                        end,
                        color = function()
                            local mode_color = {
                                n = colors.blue,
                                i = colors.green,
                                v = colors.pink,
                                [''] = colors.blue,
                                V = colors.blue,
                                c = colors.pink,
                                no = colors.red,
                                s = colors.orange,
                                S = colors.orange,
                                [''] = colors.orange,
                                ic = colors.yellow,
                                R = colors.violet,
                                Rv = colors.violet,
                                cv = colors.red,
                                ce = colors.red,
                                r = colors.blue_green,
                                rm = colors.blue_green,
                                ['r?'] = colors.blue_green,
                                ['!'] = colors.red,
                                t = colors.red,
                            }
                            return { fg = mode_color[vim.fn.mode()] }
                        end,
                        padding = { left = 0 },
                        cond = conditions.buffer_not_empty
                    },
                    {
                        "buffers",
                        show_filename_only = true,
                        hide_filename_extension = false,
                        show_modified_status = true,
                        mode = 2,
                        buffers_color = {
                            active = {
                                fg = colors.fg,
                                bg = colors.bg,
                            },
                            inactive = {
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
                    {
                        function()
                            return (" %s "):format(vim.bo.filetype:upper())
                        end,
                        padding = { left = 0 },
                        color = { fg = colors.fg },
                        cond = conditions.buffer_not_empty,
                    },
                    {
                        "filesize",
                        color = { fg = colors.fg },
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
                        color = { fg = colors.pink },
                        cond = conditions.buffer_not_empty
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
