local wezterm = require("wezterm")

local M = {}


M.get_custom_colorschemes = function()
    local custom = wezterm.color.get_builtin_schemes()["Kanagawa (Gogh)"]
    -- local custom, metadata = wezterm.color.load_base16_scheme("C:/Users/long/.config/wezterm/colors/base16-kanagawa.yaml")
    custom.background = "#161616"
    custom.split = "#727169"
    custom.tab_bar = {
        background = "#161616",
        active_tab = {
            bg_color = "#727169",
            fg_color = "#161616",
            intensity = "Bold",
            underline = "None",
            italic = false,
            strikethrough = false,
        },
        inactive_tab = {
            bg_color = "none",
            fg_color = "#727169",
        },
    }
    return {
        ["Kanagawa"] = custom,
    }
end

M.apply = function(c)
    c.color_schemes = M.get_custom_colorschemes()
    c.color_scheme = "Kanagawa"
end


return M
