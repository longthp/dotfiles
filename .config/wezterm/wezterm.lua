-- vim:fileencoding=utf-8:foldmethod=marker
local wezterm = require("wezterm")
local action = wezterm.action
local config = wezterm.config_builder()

-- default_prog {{{
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

local function get_default_prog()
    if get_os() == "windows" then
        DEFAULT_PROG = {
            "C:/Program Files/PowerShell/7-preview/pwsh.exe",
            "-NoLogo",
            "-ExecutionPolicy", "ByPass"
        }

    elseif get_os() == "linux" then
        DEFAULT_PROG = {
            "/usr/bin/bash",
            "-l"
        }
    end
    return DEFAULT_PROG
end

config.default_prog = get_default_prog()
-- }}}

-- colorscheme {{{
local custom = wezterm.color.load_scheme("C:/Users/long/.config/wezterm/colors/FlexokiDark.toml")

custom.split = "#205EA6"
custom.tab_bar = {
    background = custom.background,
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

config.color_schemes = { ["Custom"] = custom }
config.color_scheme = "Custom"
-- }}}

-- options {{{
config.inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
}

config.font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font",
    { family = "Symbols Nerd Font Mono", scale = 1.0 },
})

config.use_cap_height_to_scale_fallback_fonts = true
config.font_size = 11
config.line_height = 1.0
config.pane_focus_follows_mouse = false
config.warn_about_missing_glyphs = false
config.show_update_window = false
config.check_for_updates = false

config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.window_background_opacity = 1.0
config.window_padding = {
    left = 12,
    right = 12,
    top = 12,
    bottom = 3,
}

config.adjust_window_size_when_changing_font_size = false

config.inactive_pane_hsb = {
    saturation = 1.0,
    brightness = wezterm.GLOBAL.is_dark and 0.90 or 0.95,
}
config.enable_scroll_bar = false

config.tab_max_width = 50
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

wezterm.on(
    'format-tab-title',
    function (tab, tabs, panes, config, hover, max_width)
        return {
            { Text = ' ' .. tab.tab_index + 1 .. ' ' },
        }
    end
)

config.disable_default_key_bindings = false
config.force_reverse_video_cursor = true
-- }}}

-- menu(s) {{{
config.launch_menu = {
    { label = "Yazi", args = { "yazi" } },
    { label = "Process Viewer", args = { "btm", "--basic" } },
    {
        label = "PowerShell Core",
        args = {
            "C:/Program Files/PowerShell/7-preview/pwsh.exe",
            "-NoLogo",
            "-ExecutionPolicy", "ByPass"
        },
    },
    {
        label = "NuShell",
        args = {
            "C:/Users/long/scoop/apps/nu/current/nu.exe",
            "-l"
        },
    },
    {
        label = "Zsh",
        args = {
            "C:/Softwares/PortableGit/usr/bin/zsh.exe",
            "-l"
        }
    }
}
-- }}}

-- keys {{{
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
    -- general
    { key = 'm', mods = 'CTRL', action = action.ShowLauncherArgs { flags = 'LAUNCH_MENU_ITEMS' } },
    { key = 'b', mods = 'CTRL', action = action.ShowLauncherArgs { flags = 'TABS' } },

    { key = 'C', mods = 'CTRL', action = action.CopyTo 'Clipboard' },
    { key = 'p', mods = 'CTRL', action = action.PasteFrom 'Clipboard' },
    { key = '+', mods = 'CTRL', action = action.IncreaseFontSize },
    { key = '-', mods = 'CTRL', action = action.DecreaseFontSize },
    { key = '0', mods = 'CTRL', action = action.ResetFontSize },

    { key = 'j', mods = 'CTRL', action = action.ScrollByLine(8) },
    { key = 'k', mods = 'CTRL', action = action.ScrollByLine(-8) },

    -- panes
    { key = "s", mods = "LEADER", action = action.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "v", mods = "LEADER", action = action.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "h", mods = "LEADER", action = action.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = action.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = action.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = action.ActivatePaneDirection("Right") },
    { key = "q", mods = "LEADER", action = action.CloseCurrentPane { confirm = false} },
    { key = "z", mods = "LEADER", action = action.TogglePaneZoomState },
    { key = "o", mods = "LEADER", action = action.RotatePanes "Clockwise" },

    { key = "r", mods = "LEADER", action = action.ActivateKeyTable { name = "resize_pane", one_shot = false } },

    -- tabs
    { key = "t", mods = "LEADER", action = action.SpawnTab("CurrentPaneDomain") },
    { key = "n", mods = "LEADER", action = action.ShowTabNavigator },

    { key = "m", mods = "LEADER", action = action.ActivateKeyTable { name = "move_tab", one_shot = false } },
    { key = "{", mods = "LEADER|SHIFT", action = action.MoveTabRelative(-1) },
    { key = "}", mods = "LEADER|SHIFT", action = action.MoveTabRelative(1) },

    { key = "1", mods = "CTRL", action = action({ ActivateTab = 0 }) },
    { key = "2", mods = "CTRL", action = action({ ActivateTab = 1 }) },
    { key = "3", mods = "CTRL", action = action({ ActivateTab = 2 }) },
    { key = "4", mods = "CTRL", action = action({ ActivateTab = 3 }) },
    { key = "5", mods = "CTRL", action = action({ ActivateTab = 4 }) },
    { key = "6", mods = "CTRL", action = action({ ActivateTab = 5 }) },
    { key = "7", mods = "CTRL", action = action({ ActivateTab = 6 }) },
    { key = "8", mods = "CTRL", action = action({ ActivateTab = 7 }) },
    { key = "9", mods = "CTRL", action = action({ ActivateTab = 8 }) },
    { key = "9", mods = "CTRL", action = action({ ActivateTab = 9 }) },
}

config.key_tables = {
    resize_pane = {
        { key = "h", action = action.AdjustPaneSize { "Left", 5 } },
        { key = "j", action = action.AdjustPaneSize { "Down", 5 } },
        { key = "k", action = action.AdjustPaneSize { "Up", 5 } },
        { key = "l", action = action.AdjustPaneSize { "Right", 5 } },
        { key = "Escape", action = "PopKeyTable" },
        { key = "Enter",  action = "PopKeyTable" },
    },
    move_tab = {
        { key = "h", action = action.MoveTabRelative(-1) },
        { key = "j", action = action.MoveTabRelative(-1) },
        { key = "k", action = action.MoveTabRelative(1) },
        { key = "l", action = action.MoveTabRelative(1) },
        { key = "Escape", action = "PopKeyTable" },
        { key = "Enter", action = "PopKeyTable" },
    },
}
-- }}}

-- hyperlinks {{{
config.hyperlink_rules = {
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
-- }}}

return config
