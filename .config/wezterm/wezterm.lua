local wezterm = require("wezterm")
local act = require("wezterm").action
local c = wezterm.config_builder()

require("theme").apply(c)

local function get_os()
    local target = wezterm.target_triple
    if string.find(target, "linux") then
        return "linux"
    elseif string.find(target, "darwin") then
        return "macos"
    else
        return "windows"
    end
end


if get_os() == "windows" then
    default_prog = {
        "C:/Program Files/PowerShell/7-preview/pwsh.exe",
        "-NoLogo",
        "-ExecutionPolicy", "ByPass"
    }
    -- default_prog = {
    --     "nu.exe", "--execute", "clear"
    -- }

-- elseif get_os() == "linux" then
--     default_prog = {}
end

wezterm.on('format-tab-title', function (tab, _, _, _, _)
    return {
        { Text = ' ' .. tab.tab_index + 1 .. ' ' },
    }
end)


c.default_prog = default_prog
c.font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font",
    { family = "Symbols Nerd Font Mono", scale = 1.0 },
})

c.use_cap_height_to_scale_fallback_fonts = true
c.font_size = 12
c.line_height = 1.0
c.pane_focus_follows_mouse = false
c.warn_about_missing_glyphs = false
c.show_update_window = false
c.check_for_updates = false

c.window_decorations = "RESIZE"
c.window_close_confirmation = "NeverPrompt"
c.window_background_opacity = 1.0
c.window_padding = {
    left = 12,
    right = 12,
    top = 12,
    bottom = 0,
}
c.adjust_window_size_when_changing_font_size = false

c.inactive_pane_hsb = {
    saturation = 1.0,
    brightness = wezterm.GLOBAL.is_dark and 0.90 or 0.95,
}
c.enable_scroll_bar = false

c.tab_max_width = 50
c.tab_bar_at_bottom = true
c.use_fancy_tab_bar = false
c.show_new_tab_button_in_tab_bar = false
c.hide_tab_bar_if_only_one_tab = true

c.disable_default_key_bindings = false
c.force_reverse_video_cursor = true
c.launch_menu = {
  { label = "Process Viewer", args = { "btm", "--basic" } },
}

c.keys = require("keys")

c.hyperlink_rules = {
    {
        regex = "\\b\\w+://[\\w.-]+:[0-9]{2,15}\\S*\\b",
        format = "$0",
    },
    {
        regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
        format = "$0",
    },
    {
        regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
        format = "mailto:$0",
    },
    {
        regex = [[\bfile://\S*\b]],
        format = "$0",
    },
    {
        regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
        format = "$0",
    },
    {
        regex = [[\b[tT](\d+)\b]],
        format = "https://example.com/tasks/?t=$1",
    },
}

return c
