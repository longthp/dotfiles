return {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    enabled = true,
    config = function()
        local status, bufferline = pcall(require, "bufferline")
        if (not status) then
            return
        end

        bufferline.setup({
            options = {
                mode = "buffers",
                separator_style = "thin",
                separator_style = { "", "" },
                indicator = { style = "none" },
                buffer_close_icon = '',
                modified_icon = '●',
                close_icon = '',
                show_buffer_icons = false,
                show_buffer_close_icons = true,
                always_show_bufferline = true,
                offsets = {
                    {
                        filetype = "neo-tree",
                        -- highlight = "PanelHeading",
                        padding = 0,
                        separator = ""
                    },
                },
            },
            highlights = {
                buffer_selected = {
                    fg = normal_fg,
                    bg = normal_bg,
                    bold = false,
                    italic = false,
                },
            },
        })
    end,
}
