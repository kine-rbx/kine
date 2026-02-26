--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Theme = require(PluginRoot.Shared.Theme)

local tokens = require(PluginRoot.Helpers.tokens)

local TokensButton = require(PluginRoot.Tokens.Button)

type ButtonColors = TokensButton.ButtonColors
type ButtonVariant = TokensButton.ButtonVariant

return tokens(function() return {
	COLORS = {
		Base = Theme.colors.Secondary,
		Hover = Theme.colors.Secondary,
	} :: ButtonColors,
	VARIANT = "Ghost" :: ButtonVariant,
	PADDING = TokensButton.PADDING,
} end)
