--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local tokens = require(PluginRoot.Helpers.tokens)

local TokensGlobal = require(PluginRoot.Tokens.Global)
local TokensButton = require(PluginRoot.Tokens.Button)
local TokensTitleBar = require(PluginRoot.Tokens.TitleBar)

type ButtonColor = TokensButton.ButtonColor
type ButtonVariant = TokensButton.ButtonVariant
type ButtonVisualState = TokensButton.ButtonVisualState

return tokens(function() return {
	TEXT = {
		["CLOSE"] = "X",
		["MINIMIZE"] = "—",
	},
	TEXT_SIZE = 18,
	FONT = TokensGlobal.FONTS["MICHROMA"],
	COLOR = {
		["CLOSE"] = TokensGlobal.PALETTE["BAD"] :: ButtonColor,
		["MINIMIZE"] = "Secondary" :: ButtonColor,
	},
	VARIANT = "Ghost" :: ButtonVariant,
	SIZE = vector.create(
		TokensTitleBar.HEIGHT,
		TokensTitleBar.HEIGHT
	),
	ROUNDING = 0,
	PADDING = vector.create(
		TokensGlobal.PADDING["LARGE"],
		TokensGlobal.PADDING["LARGE"]
	),
} end)
