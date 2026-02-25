--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local tokens = require(PluginRoot.Helpers.tokens)

return tokens(function() return {
	TITLE = "Kine Editor",
	SIZE_DEFAULT = vector.create(500, 280),
	SIZE_MINIMUM = vector.create(240, 120),
} end)
