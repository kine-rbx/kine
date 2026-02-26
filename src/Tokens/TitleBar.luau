--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Theme = require(PluginRoot.Shared.Theme)

local tokens = require(PluginRoot.Helpers.tokens)

local TokensGlobal = require(PluginRoot.Tokens.Global)

return tokens(function() return {
	COLOR = Theme.colors.Secondary,
	HEIGHT = TokensGlobal.PADDING["LARGE"] * 2 + TokensGlobal.TEXT_SIZES["TITLE"],
	PADDING = vector.create(
		TokensGlobal.PADDING["LARGE"],
		TokensGlobal.PADDING["LARGE"]
	),
	SEPARATION = 1,
} end)
