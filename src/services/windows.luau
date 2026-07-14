--!strict

const plugin_root = script:FindFirstAncestor("kine")
const types = require(plugin_root.types)
const global = require(plugin_root.global)
const fluid = require(plugin_root.fluid)
const window_context = require(plugin_root.contexts.window_context)

const Window = require(plugin_root.ui.components.Window)

export type Window = {
	read tool: types.ToolKeyLoose,

	context: window_context.WindowContext?,

	read register: (Window, callback: (window_context.WindowContext) -> ()) -> (),
	read deregister: (Window) -> (),

	_cleanup: (() -> ())?,
}

const stack: { Window } = {}

local gui: ScreenGui

const function remove_value<V>(t: { V }, v: V): ()
	const i = table.find(t, v)
	if i then table.remove(t, i) end
end

const function focus(self: Window): ()
	remove_value(stack, self)
	table.insert(stack, self)

	for index, window in stack do
		const context = window.context
		if context then
			context:request_unfocus()
			context.zindex(index)
		end
	end
end

const windows = {}

const function register(self: Window, callback: (window_context.WindowContext) -> ()): ()
	self._cleanup = fluid.root(function(cleanup)
		const context = window_context.new(self.tool)
		self.context = context

		context.animating(true)
		context.focused(true)

		const instance = Window {
			WindowContext = context,
		}
		instance.Parent = gui

		fluid.cleanup(function()
			self._cleanup = nil
			self.context = nil
			instance:Destroy()
		end)

		context.on_close:once(cleanup)
		context.on_focus:connect(function()
			focus(self)
		end)

		context.open(true)

		task.defer(callback, context)
	end)
end

const function deregister(self: Window): ()
	if self._cleanup then self._cleanup() end
end

function windows.setup(tool: types.ToolKeyLoose): Window
	return {
		tool = tool,

		register = register,
		deregister = deregister,
	}
end

do
	gui = fluid.create("ScreenGui") {
		Name = "Windows",

		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
	}
	gui.Parent = global.ui_folder
end

return windows
