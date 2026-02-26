--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Theme = require(PluginRoot.Shared.Theme)

local tokens = require(PluginRoot.Helpers.tokens)

local TokensGlobal = require(PluginRoot.Tokens.Global)
local TokensButton = require(PluginRoot.Tokens.Button)

return tokens(function() return {
	COLOR = Theme.colors.Primary,
	HEIGHT = TokensGlobal.PADDING["SMALL"] * 2 + TokensButton.SIZE["MEDIUM"].y - 2,
	PADDING = vector.create(
		TokensGlobal.PADDING["SMALL"],
		TokensGlobal.PADDING["SMALL"]
	),
	SEPARATION = 0,
	BUTTON_SIZE = vector.create(
		TokensButton.SIZE["MEDIUM"].x - 2,
		TokensButton.SIZE["MEDIUM"].y - 2
	)
} end)
