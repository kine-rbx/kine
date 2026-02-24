--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local deepFreeze = require(PluginRoot.Helpers.deepFreeze)

local TokensGlobal = require(PluginRoot.Tokens.Global)

return deepFreeze {
	HEIGHT = TokensGlobal.PADDING["LARGE"] * 2 + TokensGlobal.TEXT_SIZES["TITLE"],
	PADDING = vector.create(
		TokensGlobal.PADDING["LARGE"],
		TokensGlobal.PADDING["LARGE"]
	),
	SEPARATION = 1,
}
