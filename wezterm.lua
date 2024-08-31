local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

config = wezterm.config_builder()

config.default_prog = { "pwsh" }

config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold", italic = true })
config.font_size = 10.0

-- THEMES
config.color_scheme_dirs = { "./colorscheme" }
config.color_scheme = "tokyonight_storm"

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

config.colors = {
	tab_bar = {
		background = "#0b0022",
		active_tab = {
			bg_color = "#2b2042",
			fg_color = "#c0c0c0",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#1b1032",
			fg_color = "#808080",
		},
		inactive_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
			italic = true,
		},
		new_tab = {
			bg_color = "#1b1032",
			fg_color = "#808080",
		},
		new_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
			italic = true,
		},
	},
}

config.window_padding = {
	left = 2,
	right = 2,
	top = 0,
	bottom = 0,
}

config.window_background_opacity = 0.8

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

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
	{ key = "v", mods = "CTRL|SHIFT|ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{
		key = "h",
		mods = "CTRL|SHIFT|ALT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "f",
		mods = "CTRL|SHIFT",
		action = act.TogglePaneZoomState,
	},
	{
		key = "x",
		mods = "CTRL|SHIFT|ALT",
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

require("workspace_config").on_startup()

return config
