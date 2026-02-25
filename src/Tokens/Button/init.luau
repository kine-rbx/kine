--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Theme = require(PluginRoot.Shared.Theme)

local tokens = require(PluginRoot.Helpers.tokens)

local fluid = require(PluginRoot.Packages.fluid)

local TokensGlobal = require(PluginRoot.Tokens.Global)

type ThemeColor = Theme.ThemeColor
type Source<T> = fluid.Source<T>
type UsedAs<T> = fluid.UsedAs<T>

export type ButtonColor = UsedAs<ThemeColor | Color3>
export type ButtonVariant = UsedAs<
	| "Solid"
	| "Ghost"
	| "Border"
	| "Empty"
>

export type ButtonVisualState = {
	read hovered: Source<boolean>,
	read clicked: Source<boolean>,
	read variant: ButtonVariant,
	read color: ButtonColor,
}

return tokens(function() return {
	STYLE = {
		["BACKGROUND_COLOR"] = function(state: ButtonVisualState): Color3
			local color = fluid.read(state.color)
			local color3 = typeof(color) == "Color3" and color or Theme.colors[color]()
			local variant = fluid.read(state.variant)

			if variant == "Solid" or variant == "Ghost" then
				if state.clicked() then
					return color3:Lerp(Theme.colors.Background(), TokensGlobal.FADE)
				elseif state.hovered() then
					return color3:Lerp(Theme.colors.Text(), TokensGlobal.FADE)
				end
			end

			return color3
		end,
		["BACKGROUND_TRANSPARENCY"] = function(state: ButtonVisualState): number
			local variant = fluid.read(state.variant)

			if variant == "Ghost" then
				return state.hovered() and 0 or 1
			elseif variant ~= "Solid" then
				return 1
			end

			return 0
		end,
		["BORDER_COLOR"] = function(state: ButtonVisualState): Color3
			local color = fluid.read(state.color)
			local color3 = typeof(color) == "Color3" and color or Theme.colors[color]()
			local variant = fluid.read(state.variant)

			if variant == "Border" then
				if state.clicked() then
					return color3:Lerp(Theme.colors.Background(), TokensGlobal.FADE)
				elseif state.hovered() then
					return color3:Lerp(Theme.colors.Text(), TokensGlobal.FADE)
				end
			end

			return color3
		end,
		["BORDER_TRANSPARENCY"] = function(state: ButtonVisualState): number
			local variant = fluid.read(state.variant)

			if variant == "Border" then
				return 0
			end

			return 1
		end,
	},
	SIZE = {
		["SMALL"] = vector.create(
			TokensGlobal.PADDING["MEDIUM"] * 2 + TokensGlobal.TEXT_SIZES["SMALL"],
			TokensGlobal.PADDING["MEDIUM"] * 2 + TokensGlobal.TEXT_SIZES["SMALL"]
		),
		["MEDIUM"] = vector.create(
			TokensGlobal.PADDING["MEDIUM"] * 2 + TokensGlobal.TEXT_SIZES["MEDIUM"],
			TokensGlobal.PADDING["MEDIUM"] * 2 + TokensGlobal.TEXT_SIZES["MEDIUM"]
		),
		["LARGE"] = vector.create(
			TokensGlobal.PADDING["MEDIUM"] * 2 + TokensGlobal.TEXT_SIZES["LARGE"],
			TokensGlobal.PADDING["MEDIUM"] * 2 + TokensGlobal.TEXT_SIZES["LARGE"]
		),
	},
	PADDING = vector.create(
		TokensGlobal.PADDING["MEDIUM"],
		TokensGlobal.PADDING["MEDIUM"]
	),
	TRANSITION = {
		TIME = TokensGlobal.TIMING["FAST"],
		TWEEN_INFO = {
			["HOVER"] = TweenInfo.new(
				TokensGlobal.TIMING["FAST"],
				Enum.EasingStyle.Cubic,
				Enum.EasingDirection.Out
			),
			["CLICK"] = TweenInfo.new(0),
		},
	},
} end)
