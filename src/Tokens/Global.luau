--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Theme = require(PluginRoot.Shared.Theme)

local tokens = require(PluginRoot.Helpers.tokens)

local fluid = require(PluginRoot.Packages.fluid)

local ICON_FORMAT = "rbxasset://studio_svg_textures/Shared/Alerts/%s/Standard/%s.png" :: "%s%s"

return tokens(function() return {
	PALETTE = {
		["BAD"] = fluid.derive(function()
			return if Theme.mode() == "Light"
				then Color3.fromHex("#a2120b")
				else Color3.fromHex("#ff7474")
		end),
		["WARN"] = fluid.derive(function()
			return if Theme.mode() == "Light"
				then Color3.fromHex("#bf8a00")
				else Color3.fromHex("#ffce0b")
		end),
		["GOOD"] = fluid.derive(function()
			return if Theme.mode() == "Light"
				then Color3.fromHex("#008347")
				else Color3.fromHex("#26ff9c")
		end),
		["INFO"] = fluid.derive(function()
			return if Theme.mode() == "Light"
				then Color3.fromHex("#264ccf")
				else Color3.fromHex("#78a9ff")
		end),
	},
	FONTS = {
		["DEFAULT"] = Font.fromId(12187365364), -- Inter
		["MICHROMA"] = Font.fromEnum(Enum.Font.Michroma), -- Michroma
	},
	TEXT_SIZES = {
		["SMALL"] = 10,
		["MEDIUM"] = 12,
		["LARGE"] = 16,
		["TITLE"] = 18,
	},
	ICONS = {
		["BAD"] = fluid.derive(function() return ICON_FORMAT:format(Theme.mode(), "Error") end),
		["WARN"] = fluid.derive(function() return ICON_FORMAT:format(Theme.mode(), "Warning") end),
		["GOOD"] = fluid.derive(function() return ICON_FORMAT:format(Theme.mode(), "Success") end),
		["INFO"] = fluid.derive(function() return ICON_FORMAT:format(Theme.mode(), "Information") end),
	},
	ICON_SIZES = {
		["SMALL"] = 12,
		["MEDIUM"] = 16,
		["LARGE"] = 32,
	},
	ROUNDING = {
		["SMALL"] = 3,
		["MEDIUM"] = 6,
		["LARGE"] = 9,
	},
	PADDING = {
		["SMALL"] = 2,
		["MEDIUM"] = 4,
		["LARGE"] = 8,
	},
	TIMING = {
		["VERY_FAST"] = 0.050,
		["FAST"] = 0.100,
		["MEDIUM"] = 0.200,
		["SLOW"] = 0.300,
		["VERY_SLOW"] = 0.500,
	},
	FADE = {
		["LOWERED"] = fluid.derive(function() return Theme.mode() == "Light" and 0.35 or 0.15 end),
		["ELEVATED"] = fluid.derive(function() return Theme.mode() == "Light" and 0.15 or 0.35 end),
	},
} end)
