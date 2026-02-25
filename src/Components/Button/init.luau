--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Theme = require(PluginRoot.Shared.Theme)
local Signal = require(PluginRoot.Common.Signal)

local styleTweens = require(PluginRoot.Helpers.styleTweens)

local fluid = require(PluginRoot.Packages.fluid)

local Pressable = require(PluginRoot.Components.Primitives.Pressable)
local Padding = require(PluginRoot.Components.Decorators.Padding)

local TokensGlobal = require(PluginRoot.Tokens.Global)
local TokensButton = require(PluginRoot.Tokens.Button)

type ThemeColor = Theme.ThemeColor
type Signal<T...> = Signal.Signal<T...>
type Source<T> = fluid.Source<T>
type UsedAs<T> = fluid.UsedAs<T>
type PressableState = Pressable.PressableState
type ButtonVariant = TokensButton.ButtonVariant
type ButtonColor = TokensButton.ButtonColor
type ButtonVisualState = TokensButton.ButtonVisualState

return function(props: {
	Disabled: Source<boolean>?,
	State: PressableState?,

	Text: UsedAs<string>?,
	TextSize: number?,
	Font: UsedAs<Font>?,

	IconLeft: UsedAs<string>?,
	IconRight: UsedAs<string>?,

	Variant: ButtonVariant?,
	Color: ButtonColor?,
	Size: ("Small" | "Medium" | "Large" | vector)?,
	Padding: vector?,

	Name: UsedAs<string>?,

	ZIndex: UsedAs<number>?,
	LayoutOrder: UsedAs<number>?,

	AutomaticSize: UsedAs<Enum.AutomaticSize>?,

	OnClick: Signal<>?,
	OnEnter: Signal<>?,
	OnLeave: Signal<>?,
	OnDown: Signal<>?,
	OnUp: Signal<>?,
})
	local state: PressableState = props.State or {
		hovered = fluid.source(false),
		clicked = fluid.source(false),
	}
	local visual: ButtonVisualState = {
		hovered = state.hovered,
		clicked = state.clicked,
		variant = props.Variant or "Solid" :: ButtonVariant,
		color = props.Color or "Primary" :: ThemeColor,
	}

	local tweenInfo = fluid.source(TokensButton.TRANSITION.TWEEN_INFO["CLICK"])
	local tweens = styleTweens {
		backgroundColor = {
			callback = function()
				return TokensButton.STYLE["BACKGROUND_COLOR"](visual)
			end,
			tweenInfo = tweenInfo
		},
		backgroundTransparency = {
			callback = function()
				return TokensButton.STYLE["BACKGROUND_TRANSPARENCY"](visual)
			end,
			tweenInfo = tweenInfo
		},
		borderColor = {
			callback = function()
				return TokensButton.STYLE["BORDER_COLOR"](visual)
			end,
			tweenInfo = tweenInfo
		},
		borderTransparency = {
			callback = function()
				return TokensButton.STYLE["BORDER_TRANSPARENCY"](visual)
			end,
			tweenInfo = tweenInfo
		},
	}

	fluid.effect(function()
		tweenInfo(state.clicked() and TokensButton.TRANSITION.TWEEN_INFO["CLICK"] or TokensButton.TRANSITION.TWEEN_INFO["HOVER"])
	end)

	local size: vector
	local sizeText: number
	if not props.Size or props.Size == "Medium" then
		size = TokensButton.SIZE["MEDIUM"]
		sizeText = TokensGlobal.TEXT_SIZES["MEDIUM"]
	elseif props.Size == "Large" then
		size = TokensButton.SIZE["LARGE"]
		sizeText = TokensGlobal.TEXT_SIZES["MEDIUM"]
	elseif props.Size == "Small" then
		size = TokensButton.SIZE["SMALL"]
		sizeText = TokensGlobal.TEXT_SIZES["SMALL"]
	else
		size = props.Size
		sizeText = TokensGlobal.TEXT_SIZES["MEDIUM"]
	end

	return fluid.create("Frame") {
		Name = props.Name or "Button",

		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,

		Size = UDim2.fromOffset(size.x, size.y),
		AutomaticSize = props.AutomaticSize,

		BackgroundColor3 = tweens.backgroundColor,
		BackgroundTransparency = tweens.backgroundTransparency,

		fluid.create("UIStroke") {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			BorderStrokePosition = Enum.BorderStrokePosition.Inner,

			Color = tweens.borderColor,
			Transparency = tweens.borderTransparency,
		},

		Padding(props.Padding or TokensButton.PADDING),

		Pressable {
			Disabled = props.Disabled,
			State = state,

			Size = UDim2.fromOffset(size.x, size.y),

			OnClick = props.OnClick,
			OnEnter = props.OnEnter,
			OnLeave = props.OnLeave,
			OnDown = props.OnDown,
			OnUp = props.OnUp,
		},

		if props.Text then
			fluid.create("TextLabel") {
				Name = "Text",

				Size = UDim2.fromScale(1, 1),
				AutomaticSize = props.AutomaticSize,

				BackgroundTransparency = 1,

				FontFace = props.Font or TokensGlobal.FONTS["DEFAULT"],
				Text = props.Text,
				TextSize = props.TextSize or TokensGlobal.TEXT_SIZES["MEDIUM"],
				TextColor3 = Theme.colors.Text,

				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
			}
		else nil,
	}
end
