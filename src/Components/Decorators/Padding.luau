--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local fluid = require(PluginRoot.Packages.fluid)

return function(padding: vector)
	return fluid.create("UIPadding") {
		PaddingLeft = UDim.new(0, padding.x),
		PaddingRight = UDim.new(0, padding.x),
		PaddingTop = UDim.new(0, padding.y),
		PaddingBottom = UDim.new(0, padding.y)
	}
end
