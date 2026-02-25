--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Theme = require(PluginRoot.Shared.Theme)

local deepFreeze = require(PluginRoot.Helpers.deepFreeze)

local TokensButton = require(PluginRoot.Tokens.Button)

type ButtonVariant = TokensButton.ButtonVariant

return deepFreeze {
	COLOR = Theme.colors.Secondary,
	VARIANT = "Ghost" :: ButtonVariant,
	PADDING = vector.zero,
}
