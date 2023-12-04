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

        local base16_colors = {
            base00 = "#1F1F28",
            base01 = "#2A2A37",
            base02 = "#223249",
            base03 = "#727169",
            base04 = "#C8C093",
            base05 = "#DCD7BA",
            base06 = "#938AA9",
            base07 = "#363646",
            base08 = "#C34043",
            base09 = "#FFA066",
            base0A = "#DCA561",
            base0B = "#98BB6C",
            base0C = "#7FB4CA",
            base0D = "#7E9CD8",
            base0E = "#957FB8",
            base0F = "#D27E99",
        }

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = {
                    normal = { c = { fg = colors.fg, bg = colors.bg } },
                    inactive = { c = { fg = colors.fg, bg = colors.bg } },
                },
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
                        "mode",
                        fmt = function(str)
                            return str:sub(1,3)
                        end,
                        cond = conditions.buffer_not_empty
                    },
                    -- {
                    --     function()
                    --         return "▋" .. vim.fn.mode()
                    --     end,
                    --     color = function()
                    --         local mode_color = {
                    --             n = colors.blue,
                    --             i = colors.green,
                    --             v = colors.pink,
                    --             [''] = colors.blue,
                    --             V = colors.blue,
                    --             c = colors.pink,
                    --             no = colors.red,
                    --             s = colors.orange,
                    --             S = colors.orange,
                    --             [''] = colors.orange,
                    --             ic = colors.yellow,
                    --             R = colors.violet,
                    --             Rv = colors.violet,
                    --             cv = colors.red,
                    --             ce = colors.red,
                    --             r = colors.blue_green,
                    --             rm = colors.blue_green,
                    --             ['r?'] = colors.blue_green,
                    --             ['!'] = colors.red,
                    --             t = colors.red,
                    --         }
                    --         return {
                    --             fg = mode_color[vim.fn.mode()],
                    --             bg = "#161616"
                    --         }
                    --     end,
                    --     padding = { left = 0 },
                    --     cond = conditions.buffer_not_empty
                    -- },
                    -- {
                    --     "buffers",
                    --     show_filename_only = true,
                    --     hide_filename_extension = true,
                    --     show_modified_status = true,
                    --     use_mode_colors = true,
                    --     mode = 2,
                    --     buffers_color = {
                    --         active = {
                    --             fg = "#d79921",
                    --             bg = colors.bg,
                    --         },
                    --         inactive = {
                    --             -- fg = colors.fg,
                    --             bg = colors.bg,
                    --         }
                    --     },
                    --     symbols = {
                    --         modified = " [+]",
                    --         alternate_file = "",
                    --         directory = "",
                    --     },
                    --     cond = conditions.buffer_not_empty,
                    -- },
                    {
                        function()
                            return (" %s "):format(vim.bo.filetype:upper())
                        end,
                        padding = { left = 0 },
                        color = { fg = colors.fg, bg = colors.bg },
                        cond = conditions.buffer_not_empty,
                    },
                    {
                        "filesize",
                        color = { fg = colors.fg, bg = colors.bg },
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
                        color = { fg = colors.fg, bg = colors.bg },
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
                        },
                        color = { fg = colors.fg, bg = colors.bg },
                    },
                    {
                        "diff",
                        symbols = {
                            added = ' ',
                            removed = ' ',
                            modified = ' ',
                        },
                        color = { bg = colors.bg },
                    },
                    {
                        'branch',
                        icon = { "" },
                        color = { fg = colors.fg, bg = colors.bg },
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
