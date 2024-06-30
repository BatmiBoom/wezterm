local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local config = {}

config = wezterm.config_builder()

if package.config:sub(1, 1) == "\\" then
	config.default_prog = { "C:\\Program Files\\PowerShell\\7-preview\\pwsh.exe" }
	config.font_size = 10.0
else
	config.default_prog = { "/usr/local/bin/pwsh-preview" }
	config.font_size = 12.5
end

config.default_cwd = "~"
config.color_scheme = "AdventureTime"
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold", italic = true })

-- DECORATION
config.window_decorations = "RESIZE"
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

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
	-- SESSIONS
	{ key = "s", mods = "CTRL|SHIFT", action = act({ EmitEvent = "save_session" }) },
	{ key = "l", mods = "CTRL|SHIFT", action = act({ EmitEvent = "load_session" }) },
	{ key = "b", mods = "CTRL|SHIFT", action = act({ EmitEvent = "boot_session" }) },
}

-- EVENTS

wezterm.on("gui-startup", function()
	local mode = "PERSONAL"
	if mode == "BRAINHI" then
		local projects = {
			{
				name = "COSMOS",
				cwd = "/Users/batmi/BrainHi/cosmos/",
			},
			{
				name = "TELESCOPE",
				cwd = "/Users/batmi/BrainHi/telescope/",
			},
			{
				name = "ROCKET",
				cwd = "/Users/batmi/BrainHi/rocket/",
			},
			{
				name = "COMPONENTS",
				cwd = "/Users/batmi/BrainHi/components/",
			},
			{
				name = "DOCUMENTATION",
				cwd = "/Users/batmi/BrainHi/documentation/",
			},
			{
				name = "CONFIG",
				cwd = "/Users/batmi/.config/",
			},
			{
				name = "GENERAL",
				cwd = "/Users/batmi/",
			},
		}

		for _, value in pairs(projects) do
			local code_tab, _, code_window = mux.spawn_window({
				workspace = value["name"],
				cwd = value["cwd"],
			})
			code_tab:set_title(value["name"])
			code_tab:activate()

			if value["name"] ~= "CONFIG" then
				local code_run, _, _ = code_window:spawn_tab({})
				code_run:set_title("RUN")
			end

			if value["name"] == "COSMOS" then
				local code_ssh, _, _ = code_window:spawn_tab({})
				code_ssh:set_title("SSH")
			end
		end

		mux.set_active_workspace("COSMOS")
	else
		local projects = {
			{
				name = "GENERAL",
				cwd = "C:\\Users\\nstir\\worksapce\\",
			},
			{
				name = "PROJECTS",
				cwd = "C:\\Users\\nstir\\worksapce\\github.com\\batmiboom",
			},
			{
				name = "NOTES",
				cwd = "C:\\Users\\nstir\\worksapce\\notes",
			},
			{
				name = "NVIM - PLUGINS",
				cwd = "C:\\Users\\nstir\\worksapce\\nvim",
			},
			{
				name = "CONFIG",
				cwd = "C:\\Users\\nstir\\",
			},
		}

		for _, value in pairs(projects) do
			local code_tab, _, code_window = mux.spawn_window({
				workspace = value["name"],
				cwd = value["cwd"],
			})
			code_tab:set_title(value["name"])
			code_tab:activate()

			local code_run, _, _ = code_window:spawn_tab({})
			code_run:set_title("RUN")
		end

		mux.set_active_workspace("GENERAL")
	end
end)

return config
