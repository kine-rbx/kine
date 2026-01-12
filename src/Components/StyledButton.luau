--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Design = require(PluginRoot.Shared.Design)
local Themes = require(PluginRoot.Shared.Themes)
local Signal = require(PluginRoot.Common.Signal)

local fluid = require(PluginRoot.Packages.fluid)
local source, effect, tween = fluid.source, fluid.effect, fluid.tween

local Button = require(PluginRoot.Components.Primitives.Button)

type Source<T> = fluid.Source<T>
type UsedAs<T> = fluid.UsedAs<T>
type Signal<T...> = Signal.Signal<T...>
type ButtonVisualState = Button.ButtonVisualState

export type StyleName = "Primary" | "Secondary"

type StyleFunction = (ButtonVisualState) -> Color3
type Style = {
	BackgroundColor3: StyleFunction,
	TextColor3: StyleFunction
}

local TRANSITION = Design.BUTTON.TRANSITION

local Styles: {
	[StyleName]: Style
} = {
	["Primary"] = {
		BackgroundColor3 = function(state)
			if state.clicked() then
				return Themes.colors.Primary():Lerp(Themes.colors.Text(), 0.3)
			elseif state.hovered() then
				return Themes.colors.Secondary()
			end

			return Themes.colors.Primary()
		end,
		TextColor3 = Themes.colors.Text :: StyleFunction,
	},
	["Secondary"] = {
		BackgroundColor3 = function(state)
			if state.clicked() then
				return Themes.colors.Secondary():Lerp(Themes.colors.Text(), 0.3)
			elseif state.hovered() then
				return Themes.colors.Primary()
			end

			return Themes.colors.Secondary()
		end,
		TextColor3 = Themes.colors.Text :: StyleFunction,
	},
}
table.freeze(Styles)

local function getTweens(style: Style, state: ButtonVisualState)
	local background, backgroundControls = tween(function()
		return style.BackgroundColor3(state)
	end, TRANSITION.TWEEN_INFO["HOVER"])

	local text, textControls = tween(function()
		return style.TextColor3(state)
	end, TRANSITION.TWEEN_INFO["HOVER"])

	effect(function()
		if state.clicked() then
			backgroundControls {tween_info = TRANSITION.TWEEN_INFO["CLICK"]}
			textControls {tween_info = TRANSITION.TWEEN_INFO["CLICK"]}
		else
			backgroundControls {tween_info = TRANSITION.TWEEN_INFO["HOVER"]}
			textControls {tween_info = TRANSITION.TWEEN_INFO["HOVER"]}
		end
	end)

	return {
		background = background,
		text = text,
	}
end

return function(props: {
	Style: StyleName,

	Name: UsedAs<string>?,

	ZIndex: UsedAs<number>?,
	LayoutOrder: UsedAs<number>?,

	AnchorPoint: UsedAs<Vector2>?,
	Position: UsedAs<UDim2>?,
	Size: UsedAs<UDim2>?,

	SizeConstraint: UsedAs<Enum.SizeConstraint>?,
	AutomaticSize: UsedAs<Enum.AutomaticSize>?,

	Font: UsedAs<Font>?,
	Text: UsedAs<string>?,

	TextSize: UsedAs<number>?,
	TextMargin: vector?,
	TextBounds: UsedAs<UDim2>?,

	Disabled: Source<boolean>?,

	State: ButtonVisualState?,

	OnClick: Signal<>?,
	OnEnter: Signal<>?,
	OnLeave: Signal<>?,
	OnDown: Signal<>?,
	OnUp: Signal<>?,
})
	local style = Styles[props.Style]
	local state: ButtonVisualState = props.State or {
		hovered = source(false),
		clicked = source(false)
	}

	local tweens = getTweens(style, state)

	return Button {
		Name = props.Name,

		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,

		SizeConstraint = props.SizeConstraint,
		AutomaticSize = props.AutomaticSize,

		BackgroundColor3 = tweens.background,

		Font = props.Font,
		Text = props.Text,

		TextSize = props.TextSize,
		TextColor3 = tweens.text,
		TextMargin = props.TextMargin,
		TextBounds = props.TextBounds,

		Disabled = props.Disabled,

		State = state,

		OnClick = props.OnClick,
		OnEnter = props.OnEnter,
		OnLeave = props.OnLeave,
		OnDown = props.OnDown,
		OnUp = props.OnUp
	}
end
