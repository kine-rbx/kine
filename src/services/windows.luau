--!strict

const plugin_root = script:FindFirstAncestor("kine")
const types = require(plugin_root.types)
const fluid = require(plugin_root.fluid)
const window_context = require(plugin_root.contexts.window_context)

-- manage focus and layers and passing input(?)

export type Window = {
	read tool: types.ToolKeyLoose,

	context: window_context.WindowContext?,

	read register: (Window, callback: (window_context.WindowContext) -> ()) -> (),
	read deregister: (Window) -> (),

	_cleanup: (() -> ())?,
}

const windows = {}

const function register(self: Window, callback: (window_context.WindowContext) -> ()): ()
	self._cleanup = fluid.root(function(cleanup)
		const context = window_context.new(self.tool)
		self.context = context

		fluid.cleanup(function()
			self._cleanup = nil
			self.context = nil
			context:destroy()
		end)

		context.on_close:once(cleanup)
		callback(context)
	end)
end

const function deregister(self: Window): ()
	const cleanup = self._cleanup
	self._cleanup = nil

	if cleanup then cleanup() end
end

function windows.setup(tool: types.ToolKeyLoose): Window
	return {
		tool = tool,

		register = register,
		deregister = deregister,
	}
end

return windows
