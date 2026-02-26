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
export type ButtonColors = {
	["Base"]: ButtonColor,
	["Hover"]: ButtonColor?,
	["Click"]: ButtonColor?,
}
export type ButtonVariant = UsedAs<
	| "Solid"
	| "Ghost"
	| "Border"
	| "Empty"
>

export type ButtonVisualState = {
	read hovered: Source<boolean>,
	read clicked: Source<boolean>,
	read disabled: Source<boolean>?,
	read variant: ButtonVariant,
	read colors: ButtonColors,
}

local function getColor(color: ButtonColor): Color3
	color = fluid.read(color)
	return typeof(color) == "Color3" and color or Theme.colors[color]()
end

return tokens(function() return {
	STYLE = {
		["BACKGROUND_COLOR"] = function(state: ButtonVisualState): Color3
			local variant = fluid.read(state.variant)

			if variant == "Solid" or variant == "Ghost" then
				if state.clicked() then
					return if state.colors["Click"]
						then getColor(state.colors["Click"])
						else getColor(state.colors["Base"]):Lerp(Theme.colors.Background(), TokensGlobal.FADE["LOWERED"]())
				elseif state.hovered() then
					return if state.colors["Hover"]
						then getColor(state.colors["Hover"])
						else getColor(state.colors["Base"]):Lerp(Theme.colors.Text(), TokensGlobal.FADE["ELEVATED"]())
				end
			end

			return getColor(state.colors["Base"])
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
			local variant = fluid.read(state.variant)

			if variant == "Border" then
				if state.clicked() then
					return if state.colors["Click"]
						then getColor(state.colors["Click"])
						else getColor(state.colors["Base"]):Lerp(Theme.colors.Background(), TokensGlobal.FADE["LOWERED"]())
				elseif state.hovered() then
					return if state.colors["Hover"]
						then getColor(state.colors["Hover"])
						else getColor(state.colors["Base"]):Lerp(Theme.colors.Text(), TokensGlobal.FADE["ELEVATED"]())
				end
			end

			return getColor(state.colors["Base"])
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
	ROUNDING = TokensGlobal.ROUNDING["SMALL"],
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
