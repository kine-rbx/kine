--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local deepFreeze = require(PluginRoot.Helpers.deepFreeze)

return deepFreeze {
	TITLE = "Kine Editor",
	SIZE_DEFAULT = vector.create(500, 300),
	SIZE_MINIMUM = vector.create(240, 144),
}
