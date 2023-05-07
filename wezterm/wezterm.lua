local wezterm = require 'wezterm'

local mux = wezterm.mux
local act = wezterm.action
local default_prog

wezterm.on('gui-startup', function()
    local tab, pane, window = mux.spawn_window({
        width = 140, height = 30
    })
end)

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  default_prog = { 'C:/Program Files/PowerShell/7-preview/pwsh.exe', '-NoLogo' }
end

return {
    default_prog = default_prog,
    automatically_reload_config = true,
    check_for_updates = false,
    max_fps = 60,
    color_scheme = 'Catppuccin Mocha',
    font = wezterm.font {
        family = 'JetBrainsMonoNL NF',
        weight = 'Regular',
        style = 'Normal',
        stretch = 'Normal'
    },
    font_size = 13.0,
    window_background_opacity = 1.0,
    window_decorations = "RESIZE",
    window_padding = {
        left = 2,
        right = 0,
        top = 0,
        bottom = 0
    },
    enable_tab_bar = false,
    tab_bar_at_bottom = true,
    scrollback_lines = 5000,
    use_dead_keys = false,
    disable_default_key_bindings = true,
    keys = {
        { key = 'R', mods = 'CTRL|SHIFT', action = act.ReloadConfiguration },

        { key = 'C', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
        { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
        { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
        { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
        { key = '0', mods = 'CTRL', action = act.ResetFontSize },

        { key = 'j', mods = 'CTRL', action = act.ScrollByLine(3) },
        { key = 'k', mods = 'CTRL', action = act.ScrollByLine(-3) },

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

        { key = 'b', mods = 'CTRL', action = act.RotatePanes 'CounterClockwise' },
        { key = 'n', mods = 'CTRL', action = act.RotatePanes 'Clockwise' },

        -- Tabs
        { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
        { key = 'W', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },

        { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
        { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
    },
    mouse_bindings = {
        {
            event = { Up = { streak = 1, button = 'Left' } },
            mods = 'CTRL',
            action = act.OpenLinkAtMouseCursor
        }
    }
}
