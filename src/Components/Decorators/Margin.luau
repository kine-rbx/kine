--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local fluid = require(PluginRoot.Packages.fluid)
local create = fluid.create

return function(margin: vector)
	return create("UIPadding") {
		PaddingLeft = UDim.new(0, margin.x),
		PaddingRight = UDim.new(0, margin.x),
		PaddingTop = UDim.new(0, margin.y),
		PaddingBottom = UDim.new(0, margin.y)
	}
end
