--!strict

const plugin_root = script:FindFirstAncestor("kine")
const types = require(plugin_root.types)
const fluid = require(plugin_root.fluid)
local signal = require(plugin_root.common.signal)

const Window = require(plugin_root.ui.components.Window)
const WindowContainer = require(plugin_root.ui.components.WindowContainer)

export type WindowContext = {
	read tool: types.ToolKeyLoose,

	read title: fluid.Source<string>,

	read open: fluid.Source<boolean>,
	read minimized: fluid.Source<boolean>,
	read active: fluid.Source<boolean>,

	read position: fluid.Source<vector>,
	read size: fluid.Source<vector>,

	instance: Frame?,

	read on_close: signal.Signal<>,

	read destroy: (WindowContext) -> (),
	read request_close: (WindowContext) -> (),
	read request_minimize: (WindowContext, minimized: boolean) -> (),

	_container_cleanup: (() -> ())?,
}

const function create_container(self: WindowContext): CanvasGroup | Frame
	assert(self.instance)
	const container = WindowContainer(true)
	self.instance.Parent = container
	return container
end

const window_context = {}

const function destroy(self: WindowContext): ()
	const container_cleanup = self._container_cleanup
	self._container_cleanup = nil
	const instance = self.instance
	self.instance = nil

	if container_cleanup then container_cleanup() end
	if instance then instance:Destroy() end
end

const function request_close(self: WindowContext): ()
	-- TODO: some sort of system to block close requests
	self.open(false)
	self.on_close:fire()
end

const function request_minimize(self: WindowContext, minimized: boolean): ()
	self.minimized(minimized)
end

function window_context.new(tool: types.ToolKeyLoose): WindowContext
	const self: WindowContext = {
		tool = tool,

		title = fluid.source(""),

		open = fluid.source(false),
		minimized = fluid.source(false),
		active = fluid.source(false),

		position = fluid.source(vector.zero),
		size = fluid.source(vector.one),

		instance = Window {},

		on_close = signal.new(),

		destroy = destroy,
		request_close = request_close,
		request_minimize = request_minimize,
	}

	self._container_cleanup = fluid.root(function()
		const container = create_container(self)

		fluid.cleanup(function()
			container:Destroy()
		end)
	end)

	return self
end

return window_context
