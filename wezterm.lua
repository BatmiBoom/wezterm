local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

config = wezterm.config_builder()

config.default_prog = { "pwsh-preview" }

config.font = wezterm.font("IosevkaTerm Nerd Font", { weight = "Bold", italic = false })
config.font_size = 15.0

-- THEMES
config.color_scheme_dirs = { "./colorscheme" }
config.color_scheme = "carboxfox"

-- DECORATION
config.window_decorations = "RESIZE"
config.enable_tab_bar = true
config.use_fancy_tab_bar = false

-- WINDOW
config.window_frame = {
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	font_size = 9.0,
	active_titlebar_bg = "#333333",
	inactive_titlebar_bg = "#333333",
}

config.window_padding = {
	left = 1,
	right = 1,
	top = 0,
	bottom = 0,
}

config.window_background_opacity = 1.0

-- KEYS
config.keys = {
	-- TABS
	{ key = "t", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
	{
		key = "x",
		mods = "CTRL|SHIFT",
		action = act.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- PANES
	{ key = "v", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "f",
		mods = "CTRL|SHIFT",
		action = act.TogglePaneZoomState,
	},
	{
		key = "x",
		mods = "CTRL|SHIFT",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	-- WORKSPACES
	{ key = "w", mods = "CTRL|SHIFT", action = act.SwitchToWorkspace },
	{
		key = "q",
		mods = "CTRL|SHIFT",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
	-- WINDOWS
	{ key = "n", mods = "CTRL|SHIFT", action = act.SpawnWindow },
}

-- EVENTS START UP
require("workspace_config").on_startup()

-- PLUGINS
require("smart_splits").smart_split(wezterm, config)

return config
