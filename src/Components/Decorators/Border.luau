--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Themes = require(PluginRoot.Shared.Themes)

local fluid = require(PluginRoot.Packages.fluid)
local create = fluid.create

return function()
	return create("UIStroke") {
		Color = Themes.colors.Border
	}
end
