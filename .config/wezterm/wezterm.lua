local wezterm = require("wezterm")
local act = require("wezterm").action

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    default_prog = {
        'C:/Program Files/PowerShell/7-preview/pwsh.exe',
        '-NoLogo',
        '-ExecutionPolicy', 'ByPass'
    }
end

wezterm.on('format-tab-title', function (tab, _, _, _, _)
    return {
        { Text = ' ' .. tab.tab_index + 1 .. ' ' },
    }
end)

wezterm.on('toggle-opacity', function(window, pane)
    local overrides = window:get_config_overrides() or {}
    if not overrides.window_background_opacity then
        overrides.window_background_opacity = 0.90
    else
        overrides.window_background_opacity = nil
    end
    window:set_config_overrides(overrides)
end)

return {
    default_prog = default_prog,
    font = wezterm.font_with_fallback({
        "JetBrainsMono Nerd Font",
        { family = "Symbols Nerd Font Mono", scale = 1.0 },
    }),
    use_cap_height_to_scale_fallback_fonts = true,
    font_size = 12,
    line_height = 1.0,
    pane_focus_follows_mouse = false,
    warn_about_missing_glyphs = false,
    show_update_window = false,
    check_for_updates = false,
    window_decorations = "RESIZE",
    window_close_confirmation = "NeverPrompt",
    window_padding = {
        left = 12,
        right = 12,
        top = 12,
        bottom = 0,
    },
    inactive_pane_hsb = {
        saturation = 1.0,
        brightness = wezterm.GLOBAL.is_dark and 0.90 or 0.95,
    },
    enable_scroll_bar = false,
    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    show_new_tab_button_in_tab_bar = false,
    window_background_opacity = 1.0,
    tab_max_width = 50,
    hide_tab_bar_if_only_one_tab = true,
    disable_default_key_bindings = false,
    color_scheme = "carbonfox",
    keys = {
        { key = 'R', mods = 'CTRL|SHIFT', action = act.ReloadConfiguration },

        { key = 'C', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
        { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
        { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
        { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
        { key = '0', mods = 'CTRL', action = act.ResetFontSize },

        { key = 'j', mods = 'CTRL', action = act.ScrollByLine(8) },
        { key = 'k', mods = 'CTRL', action = act.ScrollByLine(-8) },

        -- Panes
        { key = 'f', mods = 'CTRL', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
        { key = 'd', mods = 'CTRL', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        { key = 'x', mods = 'CTRL', action = act.CloseCurrentPane { confirm = false } },

        { key = 'J', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },
        { key = 'K', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
        { key = 'H', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
        { key = 'L', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },

        { key = 'P', mods = 'CTRL|SHIFT', action = act.AdjustPaneSize { 'Left', 5 } },
        { key = 'U', mods = 'CTRL|SHIFT', action = act.AdjustPaneSize { 'Right', 5 } },
        { key = 'I', mods = 'CTRL|SHIFT', action = act.AdjustPaneSize { 'Down', 5 } },
        { key = 'O', mods = 'CTRL|SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },

        -- { key = 'b', mods = 'CTRL', action = act.RotatePanes 'CounterClockwise' },
        -- { key = 'n', mods = 'CTRL', action = act.RotatePanes 'Clockwise' },

        -- Tabs
        { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
        { key = 'W', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },

        { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
        { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },

        { key = "1", mods = "CTRL", action = wezterm.action({ ActivateTab = 0 }) },
        { key = "2", mods = "CTRL", action = wezterm.action({ ActivateTab = 1 }) },
        { key = "3", mods = "CTRL", action = wezterm.action({ ActivateTab = 2 }) },
        { key = "4", mods = "CTRL", action = wezterm.action({ ActivateTab = 3 }) },
        { key = "5", mods = "CTRL", action = wezterm.action({ ActivateTab = 4 }) },
        { key = "6", mods = "CTRL", action = wezterm.action({ ActivateTab = 5 }) },
        { key = "7", mods = "CTRL", action = wezterm.action({ ActivateTab = 6 }) },
        { key = "8", mods = "CTRL", action = wezterm.action({ ActivateTab = 7 }) },
        { key = "9", mods = "CTRL", action = wezterm.action({ ActivateTab = 8 }) },
        { key = "9", mods = "CTRL", action = wezterm.action({ ActivateTab = 9 }) },
        { key = 'B', mods = 'CTRL', action = wezterm.action.EmitEvent 'toggle-opacity' },
    },
    hyperlink_rules = {
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
    },
}
