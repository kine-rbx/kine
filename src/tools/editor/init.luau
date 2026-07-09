--!strict

const plugin_root = script:FindFirstAncestor("kine")
const types = require(plugin_root.types)
const global = require(plugin_root.global)
const fluid = require(plugin_root.fluid)
const plug = require(plugin_root.services.plug)
const windows = require(plugin_root.services.windows)
const window_context = require(plugin_root.contexts.window_context)

const TOOL_NAME: types.ToolKey = "Editor"

return function(): ()
	const tool_button = plug.add_tool_button("editor", {
		name = TOOL_NAME,
		tooltip = "Create and edit animations",
		icon = "",
	})

	const window = windows.setup(TOOL_NAME)

	const function setup(window_context: window_context.WindowContext): ()
		-- this is so much better oh my god
		print("window has been set up!!!")
	end

	tool_button.on_click:connect(function()
		const context = window.context
		if context then
			if context.minimized() then
				context:request_minimize(false)
			else
				context:request_close()
			end
		else
			window:deregister()
			window:register(setup)
		end
	end)
end
