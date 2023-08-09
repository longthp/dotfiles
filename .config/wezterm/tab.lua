local wezterm = require("wezterm")
local palette = require("theme").palette

local Tab = {}

local function get_process(pane)
	local process_icons = {
		["docker"] = {
			{ Text = "󰡨" },
		},
		["docker-compose"] = {
			{ Text = "󰡨" },
		},
		["nvim.exe"] = {
			{ Text = "hoho" },
		},
		["bob"] = {
			{ Text = "" },
		},
		["vim.exe"] = {
			{ Text = "" },
		},
		["VIM.exe"] = {
			{ Text = "" },
		},
		["node"] = {
			{ Text = "󰋘" },
		},
		["htop"] = {
			{ Text = "" },
		},
		["btop"] = {
			{ Text = "" },
		},
		["cargo"] = {
			{ Text = wezterm.nerdfonts.dev_rust },
		},
		["go"] = {
			{ Text = "" },
		},
		["git"] = {
			{ Text = "󰊢" },
		},
		["lazygit"] = {
			{ Text = "󰊢" },
		},
		["lua"] = {
			{ Text = "" },
		},
		["wget"] = {
			{ Text = "󰄠" },
		},
		["curl"] = {
			{ Text = "" },
		},
		["gh"] = {
			{ Text = "" },
		},
        ["pwsh.exe"] = {
            { Text = "󰨊" }
        },
        ["lf"] = {
            { Text = ""}
        }
	}

    function basename(s)
        return string.gsub(s, "(.*[/\\])(.*)", "%2")
    end

	local process_name = basename(pane:get_foreground_process_name())

	-- if not process_name then
	-- 	process_name = "pwsh"
	-- end

	-- return wezterm.format(
	-- 	process_icons[process_name] or {
 --            { Text = string.format("[%s]", process_name) }
 --        }
	-- )
    return process_icons[process_name]
end

function Tab.setup()
	wezterm.on("format-tab-title", function(tab, pane)
		return wezterm.format({
			{ Text = string.format(" %s  ", tab.tab_index + 1) },
			{ Text = get_process(pane) },
			{ Text = " " },
			{ Text = "  " },
		})
	end)
end

return Tab
