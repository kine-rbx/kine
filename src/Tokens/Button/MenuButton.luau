--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Theme = require(PluginRoot.Shared.Theme)

local tokens = require(PluginRoot.Helpers.tokens)

local TokensButton = require(PluginRoot.Tokens.Button)

type ButtonVariant = TokensButton.ButtonVariant

return tokens(function() return {
	COLOR = Theme.colors.Secondary,
	VARIANT = "Ghost" :: ButtonVariant,
	PADDING = TokensButton.PADDING,
} end)
