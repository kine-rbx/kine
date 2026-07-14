--!strict

const plugin_root = script:FindFirstAncestor("kine")
const fluid = require(plugin_root.fluid)
local signal = require(plugin_root.common.signal)

export type WindowContext = {
	read name: string,

	read open: fluid.Source<boolean>,
	read active: fluid.Source<boolean>,
	read focused: fluid.Source<boolean>,
	read hidden: fluid.Source<boolean>,
	read animating: fluid.Source<boolean>,

	read position: fluid.Source<vector>,
	read size: fluid.Source<vector>,
	read zindex: fluid.Source<number>,

	instance: Frame?,

	read on_close: signal.Signal<>,
	read on_focus: signal.Signal<>,
	read on_unfocus: signal.Signal<>,
	read on_hide: signal.Signal<>,
	read on_unhide: signal.Signal<>,

	read request_close: (WindowContext) -> (),
	read request_focus: (WindowContext) -> (),
	read request_unfocus: (WindowContext) -> (),
	read request_hide: (WindowContext) -> (),
	read request_unhide: (WindowContext) -> (),
}

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

function window_context.new(name: string): WindowContext
	return {
		name = name,

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
	}
end

return window_context
