--!strict

const plugin_root = script:FindFirstAncestor("kine")
const types = require(plugin_root.types)
const plug = require(plugin_root.services.plug)
const windows = require(plugin_root.services.windows)
const window_context = require(plugin_root.contexts.window_context)

const TOOL_NAME: types.ToolKey = "Editor"

const DEFAULT_WINDOW_SIZE = vector.create(330, 200)

return function(): ()
	const tool_button = plug.add_tool_button("editor", {
		name = TOOL_NAME,
		tooltip = "Create and edit animations",
		icon = "",
	})

	const window = windows.setup(TOOL_NAME)

	const function setup(window_context: window_context.WindowContext): ()
		print("window has been set up!!!")

		assert(window.context)
		window.context.size(DEFAULT_WINDOW_SIZE)
	end

	tool_button.on_click:connect(function()
		const context = window.context
		if context then
			if context.hidden() then
				context:request_unhide()
			else
				context:request_close()
			end
		else
			window:deregister()
			window:register(setup)
		end
	end)
end
