--!strict

const plugin_root = script:FindFirstAncestor("kine")
const global = require(plugin_root.global)
const fluid = require(plugin_root.fluid)
const plug = require(plugin_root.services.plug)
const window_context = require(plugin_root.contexts.window_context)

return function(): ()
	local tool_button: plug.ToolButton
	local active_gui: ScreenGui

	local window: window_context.WindowContext? = nil
	local window_cleanup: (() -> ())? = nil

	-- TODO: window context should manage this dumbass

	const function die(): ()
		if window_cleanup then window_cleanup() end
		window_cleanup = nil
	end

	const function setup(): ()
		window = window_context.new("Editor")
	end

	const function on_click(): ()
		if window_cleanup and window then
			if window.minimized() then
				window:request_minimize(false)
			else
				window:request_close()
			end
		else
			die()
			window_cleanup = fluid.root(setup)
		end
	end

	active_gui = fluid.create("ScreenGui") {
		Name = "Editor",
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

		Parent = global.ui_folder,
	}

	tool_button = plug.add_tool_button("editor", {
		name = "Editor",
		tooltip = "Create and edit animations",
		icon = "",

		on_click = on_click,
	})
end
