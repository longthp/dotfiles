local wezterm = require("wezterm")
local config = wezterm.config_builder()


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


wezterm.on(
    'format-tab-title',
    function (tab, tabs, panes, config, hover, max_width)
        return {
            { Text = ' ' .. tab.tab_index + 1 .. ' ' },
        }
    end
)


config.default_prog = get_default_prog()

config.color_schemes = require("theme")
config.color_scheme = "Custom"

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

config.disable_default_key_bindings = false
config.force_reverse_video_cursor = true
config.launch_menu = {
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

config.keys = require("keys")

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

return config
