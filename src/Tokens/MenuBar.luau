--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local deepFreeze = require(PluginRoot.Helpers.deepFreeze)

local TokensGlobal = require(PluginRoot.Tokens.Global)
local TokensButton = require(PluginRoot.Tokens.Button)

return deepFreeze {
	HEIGHT = TokensGlobal.PADDING["SMALL"] * 2 + TokensButton.SIZE["MEDIUM"].y,
	PADDING = vector.create(
		TokensGlobal.PADDING["SMALL"],
		TokensGlobal.PADDING["SMALL"]
	),
	SEPARATION = 1,
}
