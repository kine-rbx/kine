--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local deepFreeze = require(PluginRoot.Helpers.deepFreeze)

local TokensGlobal = require(PluginRoot.Tokens.Global)
local TokensButton = require(PluginRoot.Tokens.Button)
local TokensTitleBar = require(PluginRoot.Tokens.TitleBar)

type ButtonColor = TokensButton.ButtonColor
type ButtonVariant = TokensButton.ButtonVariant
type ButtonVisualState = TokensButton.ButtonVisualState

return deepFreeze {
	FONT = TokensGlobal.FONTS["MICHROMA"],
	TEXT = {
		["CLOSE"] = "X",
		["MINIMIZE"] = "—",
	},
	COLOR = {
		["CLOSE"] = TokensGlobal.PALETTE["BAD"] :: ButtonColor,
		["MINIMIZE"] = "Secondary" :: ButtonColor,
	},
	VARIANT = "Ghost" :: ButtonVariant,
	SIZE = vector.create(
		TokensTitleBar.HEIGHT,
		TokensTitleBar.HEIGHT
	),
	PADDING = vector.create(
		TokensGlobal.PADDING["LARGE"],
		TokensGlobal.PADDING["LARGE"]
	),
}
