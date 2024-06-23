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

wezterm.on("gui-startup", function(cmd)
	local mode = os.getenv("DEV_MODE")
	if mode == "BRANIHI" then
		-- COSMOS
		local cosmos_code, _, cosmos_window = mux.spawn_window({
			workspace = "cosmos",
			cwd = "~/BrainHi/cosmos",
		})
		cosmos_code:set_title("COSMOS")

		local cosmos_run, _, _ = cosmos_window:spawn_tab({})
		cosmos_run:set_title("RUN")

		local cosmos_ssh, _, _ = cosmos_window:spawn_tab({})
		cosmos_ssh:set_title("SSH")

		-- TELESCOPE
		local telescope_code, _, telescope_window = mux.spawn_window({
			workspace = "telescope",
			cwd = "~/BrainHi/telescope",
		})
		telescope_code:set_title("TELESCOPE")

		local telescope_run, _, _ = telescope_window:spawn_tab({})
		telescope_run:set_title("RUN")

		-- ROCKET
		local rocket_code, _, rocket_window = mux.spawn_window({
			workspace = "rocket",
			cwd = "~/BrainHi/rocket",
		})
		rocket_code:set_title("ROCKET")

		local rocket_run, _, _ = rocket_window:spawn_tab({})
		rocket_run:set_title("RUN")

		-- COMPONENTS
		local components_code, _, components_window = mux.spawn_window({
			workspace = "components",
			cwd = "~/BrainHi/components",
		})
		components_code:set_title("COMPONENTS")

		local components_compile, _, _ = components_window:spawn_tab({})
		components_compile.set_title("COMPILE")

		-- GENERAL
		local general_tab, _, general_window = mux.spawn_window({
			workspace = "general",
			cwd = "~",
		})
		general_tab:set_title("GENERAL")

		-- START
		mux.set_active_workspace("general")
		general_window:gui_window():maximize()
	else
		-- CODE
		local ws_tab, _, ws_window = mux.spawn_window({
			workspace = "windows",
			cwd = "~/workspace/",
		})
		ws_tab:set_title("CODE")

		-- NOTES
		local notes_tab, _, _ = ws_window:spawn_tab({})
		notes_tab:set_title("NOTES")

		-- WSL
		local wsl_tab, _, _ = ws_window:spawn_tab({})
		wsl_tab:set_title("WSL")

		-- CONFIG
		local config_tab, _, _ = ws_window:spawn_tab({})
		config_tab:set_title("CONFIG")

		-- START
		mux.set_active_workspace("windows")
		ws_window:gui_window():maximize()
	end
end)

return config
