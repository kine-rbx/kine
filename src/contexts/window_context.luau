--!strict

const plugin_root = script:FindFirstAncestor("kine")
const fluid = require(plugin_root.fluid)
const signal = require(plugin_root.common.signal)
const context_types = require(plugin_root.contexts.context_types)

const Window = require(plugin_root.ui.components.Window)

export type WindowContext = context_types.WindowContext

const window_context = {}

const function request_close(self: WindowContext): ()
	-- TODO: some sort of system to block close requests
	self.open(false)
	self.active(false)
	self.on_close:fire()
end

const function request_focus(self: WindowContext): ()
	self.focused(true)
	self.active(true)
	self.on_focus:fire()
end

const function request_unfocus(self: WindowContext): ()
	self.focused(false)
	self.active(false)
	self.on_unfocus:fire()
end

const function request_hide(self: WindowContext): ()
	self.hidden(true)
	self.active(false)
	self.on_hide:fire()
end

const function request_unhide(self: WindowContext): ()
	self.hidden(false)
	self.active(true)
	self.on_unhide:fire()
end

function window_context.new(id: string): WindowContext
	const context: WindowContext = {
		id = id,

		open = fluid.source(false),
		active = fluid.source(false),
		focused = fluid.source(false),
		hidden = fluid.source(false),
		animating = fluid.source(false),

		position = fluid.source(vector.zero),
		size = fluid.source(vector.one),
		zindex = fluid.source(0),

		on_close = signal.new(),
		on_focus = signal.new(),
		on_unfocus = signal.new(),
		on_hide = signal.new(),
		on_unhide = signal.new(),

		request_close = request_close,
		request_focus = request_focus,
		request_unfocus = request_unfocus,
		request_hide = request_hide,
		request_unhide = request_unhide,
	} :: WindowContext

	context.instance = Window {
		WindowContext = context,
	}

	return context
end

return window_context
