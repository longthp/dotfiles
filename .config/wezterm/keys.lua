local wezterm = require("wezterm")
local act = require("wezterm").action

local function is_vi_process(pane)
	return pane:get_foreground_process_name():find("n?vim") ~= nil
end

local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "SHIFT|ALT" or "ALT",
		action = wezterm.action_callback(function(win, pane)
			if is_vi_process(pane) then
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "SHIFT|ALT" or "ALT" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

return {
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
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

    { key = "M", mods = "CTRL|SHIFT", action = act.ShowLauncher }
}
