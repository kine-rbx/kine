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
type ButtonColors = TokensButton.ButtonColors
type ButtonVisualState = TokensButton.ButtonVisualState

return function(props: {
	Disabled: Source<boolean>?,
	State: PressableState?,

	Text: UsedAs<string>?,
	TextSize: number?,
	Font: UsedAs<Font>?,

	IconLeft: UsedAs<string>?,
	IconRight: UsedAs<string>?,

	Colors: ButtonColors?,
	Variant: ButtonVariant?,
	Size: ("Small" | "Medium" | "Large" | vector)?,
	Padding: vector?,
	Rounding: number?,

	Name: UsedAs<string>?,

	ZIndex: UsedAs<number>?,
	LayoutOrder: UsedAs<number>?,

	AutomaticSize: UsedAs<Enum.AutomaticSize>?,
	HorizontalAlignment: UsedAs<Enum.HorizontalAlignment>?,

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
		disabled = props.Disabled,
		variant = props.Variant or "Solid" :: ButtonVariant,
		colors = props.Colors or {["Base"] = "Primary" :: ThemeColor},
	}

	local tweenInfo = fluid.source(TokensButton.TRANSITION.TWEEN_INFO["CLICK"])

	fluid.effect(function()
		tweenInfo(state.clicked() and TokensButton.TRANSITION.TWEEN_INFO["CLICK"] or TokensButton.TRANSITION.TWEEN_INFO["HOVER"])
	end)

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

	local size: vector
	if not props.Size or props.Size == "Medium" then
		size = TokensButton.SIZE["MEDIUM"]
	elseif props.Size == "Large" then
		size = TokensButton.SIZE["LARGE"]
	elseif props.Size == "Small" then
		size = TokensButton.SIZE["SMALL"]
	else
		size = props.Size
	end

	local container: Frame
	local function getContainer(): Frame
		if container then return container end
		container = fluid.create("Frame") {
			Name = "Container",

			Size = UDim2.fromScale(1, 1),
			AutomaticSize = Enum.AutomaticSize.X,

			BackgroundTransparency = 1,
			BorderSizePixel = 0,

			Padding(props.Padding or TokensButton.PADDING),

			fluid.create("UIListLayout") {
				Padding = UDim.new(0, TokensButton.ICON_SEPARATION),

				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,

				HorizontalAlignment = props.HorizontalAlignment or Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
			},
		}
		return container
	end

	if props.IconLeft then
		fluid.create("ImageLabel") {
			Name = "IconLeft",

			LayoutOrder = 0,

			Size = UDim2.fromOffset(TokensGlobal.ICON_SIZES["MEDIUM"], TokensGlobal.ICON_SIZES["MEDIUM"]),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,

			BackgroundTransparency = 1,
			BorderSizePixel = 0,

			Image = props.IconLeft,
			ScaleType = Enum.ScaleType.Fit,
		}.Parent = getContainer()
	end

	if props.IconRight then
		fluid.create("ImageLabel") {
			Name = "IconRight",

			LayoutOrder = 2,

			Size = UDim2.fromOffset(TokensGlobal.ICON_SIZES["MEDIUM"], TokensGlobal.ICON_SIZES["MEDIUM"]),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,

			BackgroundTransparency = 1,
			BorderSizePixel = 0,

			Image = props.IconRight,
			ScaleType = Enum.ScaleType.Fit,
		}.Parent = getContainer()
	end

	if props.Text then
		fluid.create("TextLabel") {
			Name = "Text",

			LayoutOrder = 1,

			Size = UDim2.fromScale(0, 1),
			AutomaticSize = Enum.AutomaticSize.X,

			BackgroundTransparency = 1,
			BorderSizePixel = 0,

			FontFace = props.Font or TokensGlobal.FONTS["DEFAULT"],
			Text = props.Text,
			TextSize = props.TextSize or TokensGlobal.TEXT_SIZES["MEDIUM"],
			TextColor3 = Theme.colors.Text,

			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
		}.Parent = getContainer()
	end

	return fluid.create("Frame") {
		Name = props.Name or "Button",

		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,

		Size = UDim2.fromOffset(size.x, size.y),
		AutomaticSize = props.AutomaticSize or Enum.AutomaticSize.X,

		BackgroundColor3 = tweens.backgroundColor,
		BackgroundTransparency = tweens.backgroundTransparency,
		BorderSizePixel = 0,

		fluid.create("UIStroke") {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			BorderStrokePosition = Enum.BorderStrokePosition.Inner,

			Color = tweens.borderColor,
			Transparency = tweens.borderTransparency,
		},

		fluid.create("UICorner") {
			CornerRadius = UDim.new(0, props.Rounding or TokensButton.ROUNDING)
		},

		Pressable {
			Disabled = props.Disabled,
			State = state,

			Size = UDim2.fromScale(1, 1),

			OnClick = props.OnClick,
			OnEnter = props.OnEnter,
			OnLeave = props.OnLeave,
			OnDown = props.OnDown,
			OnUp = props.OnUp,
		},

		container,
	}
end
