--!strict

const plugin_root = script:FindFirstAncestor("kine")
const fluid = require(plugin_root.fluid)

return function(props: {}): Frame
	return fluid.create("Frame") {}
end
