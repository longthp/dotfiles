return {
    "nanozuki/tabby.nvim",
    event = "BufEnter",
    config = function()
        local theme = {
            fill = 'TabLineFill',
            -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
            head = 'TabLine',
            current_tab = 'TabLineSel',
            tab = 'TabLine',
            win = 'TabLine',
            tail = 'TabLine',
        }

        local colors = require("catppuccin.palettes").get_palette()

        require('tabby.tabline').use_preset('tab_only', {
            theme = {
                fill = 'TabLineFill', -- tabline background
                head = 'TabLine', -- head element highlight
                current_tab = 'TabLineSel', -- current tab label highlight
                tab = 'TabLine', -- other tab label highlight
                win = 'TabLine', -- window highlight
                tail = 'TabLine', -- tail element highlight
            },
            nerdfont = true, -- whether use nerdfont
            tab_name = {
                -- name_fallback = function()
                -- end
            },
            buf_name = {
                mode = "relative",
            },
        })
    end,
}
