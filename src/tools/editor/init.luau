--!strict

local plugin_root = script:FindFirstAncestor("kine")
local plug = require(plugin_root.service.plug)

return function(): ()
	local tool_button: plug.ToolButton

	local function on_click(): ()
		print("editor clicked")
		tool_button:reset()
	end

	tool_button = plug.add_tool_button("editor", {
		name = "Editor",
		tooltip = "Create and edit animations",
		icon = "",

		on_click = on_click,
	})
end
