--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local tokens = require(PluginRoot.Helpers.tokens)

local TokensGlobal = require(PluginRoot.Tokens.Global)
local TokensButton = require(PluginRoot.Tokens.Button)

return tokens(function() return {
	HEIGHT = TokensGlobal.PADDING["SMALL"] * 2 + TokensButton.SIZE["MEDIUM"].y,
	PADDING = vector.create(
		TokensGlobal.PADDING["SMALL"],
		TokensGlobal.PADDING["SMALL"]
	),
	SEPARATION = 1,
} end)
