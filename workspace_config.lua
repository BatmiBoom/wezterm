local wezterm = require("wezterm")
local mux = wezterm.mux

local M = {}

function M.on_startup()
	wezterm.on("gui-startup", function()
		local projects = {
			{
				name = "GENERAL",
				cwd = "C:/Users/nstir/",
			},
			{
				name = "PROJECTS",
				cwd = "C:/Users/nstir/workspace/github.com/batmiboom",
			},
			{
				name = "CONFIG",
				cwd = "C:/Users/nstir/.config",
			},
		}

		for _, value in pairs(projects) do
			local code_tab, _, code_window = mux.spawn_window({
				workspace = value["name"],
				cwd = value["cwd"],
			})
			code_tab:set_title(value["name"])

			if value["name"] == "PROJECTS" then
				local notes_tab, _, _ = code_window:spawn_tab({
					cwd = "C:/Users/nstir/workspace/notes",
				})
				notes_tab:set_title("NOTES")
			end

			code_tab:activate()
		end

		mux.set_active_workspace("GENERAL")
	end)
end

return M
