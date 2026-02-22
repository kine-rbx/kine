--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Theme = require(PluginRoot.Shared.Theme)

local deepFreeze = require(PluginRoot.Helpers.deepFreeze)

local fluid = require(PluginRoot.Packages.fluid)

local TokensGlobal = require(PluginRoot.Tokens.Global)

type ThemeColor = Theme.ThemeColor
type Source<T> = fluid.Source<T>
type UsedAs<T> = fluid.UsedAs<T>

export type ButtonVariant =
	| "Solid"
	| "Ghost"
	| "Border"
	| "Empty"

export type ButtonVisualState = {
	read hovered: Source<boolean>,
	read clicked: Source<boolean>,
	read variant: UsedAs<ButtonVariant>,
	read color: UsedAs<ThemeColor>,
}

return deepFreeze {
	STYLE = {
		["BACKGROUND_COLOR"] = function(state: ButtonVisualState): Color3
			local color = Theme.colors[fluid.read(state.color)]()
			local variant = fluid.read(state.variant)

			if variant == "Solid" or variant == "Ghost" then
				if state.clicked() then
					return color:Lerp(Theme.colors.Background(), TokensGlobal.FADE)
				elseif state.hovered() then
					return color:Lerp(Theme.colors.Text(), TokensGlobal.FADE)
				end
			end

			return color
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
			local color = Theme.colors[fluid.read(state.color)]()
			local variant = fluid.read(state.variant)

			if variant == "Border" then
				if state.clicked() then
					return color:Lerp(Theme.colors.Background(), TokensGlobal.FADE)
				elseif state.hovered() then
					return color:Lerp(Theme.colors.Text(), TokensGlobal.FADE)
				end
			end

			return color
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
			TokensGlobal.PADDING["MEDIUM"] + TokensGlobal.TEXT_SIZES["SMALL"],
			TokensGlobal.PADDING["MEDIUM"] + TokensGlobal.TEXT_SIZES["SMALL"]
		),
		["MEDIUM"] = vector.create(
			TokensGlobal.PADDING["MEDIUM"] + TokensGlobal.TEXT_SIZES["MEDIUM"],
			TokensGlobal.PADDING["MEDIUM"] + TokensGlobal.TEXT_SIZES["MEDIUM"]
		),
		["LARGE"] = vector.create(
			TokensGlobal.PADDING["MEDIUM"] + TokensGlobal.TEXT_SIZES["LARGE"],
			TokensGlobal.PADDING["MEDIUM"] + TokensGlobal.TEXT_SIZES["LARGE"]
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
}
