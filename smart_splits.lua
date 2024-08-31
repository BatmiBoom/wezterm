local M = {}

function M.smart_split(wezterm, config)
	local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

	smart_splits.apply_to_config(config)
end

return M
