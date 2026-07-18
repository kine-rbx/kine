--!strict

const plugin_root = script:FindFirstAncestor("kine")
const fluid = require(plugin_root.fluid)
const signal = require(plugin_root.common.signal)

export type WindowContext = {
	read id: string,

	instance: Frame,
	container: Frame,

	read open: fluid.Source<boolean>,
	read active: fluid.Source<boolean>,
	read focused: fluid.Source<boolean>,
	read hidden: fluid.Source<boolean>,
	read animating: fluid.Source<boolean>,

	read position: fluid.Source<vector>,
	read size: fluid.Source<vector>,
	read index: fluid.Source<number>,

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

return nil
