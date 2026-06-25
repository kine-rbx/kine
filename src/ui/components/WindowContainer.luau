--!strict

const plugin_root = script:FindFirstAncestor("kine")
const fluid = require(plugin_root.fluid)

return function(animating: boolean): CanvasGroup | Frame
	if animating then
		return fluid.create("CanvasGroup") {}
	else
		return fluid.create("Frame") {}
	end
end :: ((true) -> CanvasGroup) & ((false) -> Frame)
