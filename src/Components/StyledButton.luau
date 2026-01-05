--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Design = require(PluginRoot.Shared.Design)
local Themes = require(PluginRoot.Shared.Themes)
local Signal = require(PluginRoot.Utility.Signal)

local fluid = require(PluginRoot.Packages.fluid)
local source, tween = fluid.source, fluid.tween

local Button = require(PluginRoot.Components.Primitives.Button)

type Source<T> = fluid.Source<T>
type UsedAs<T> = fluid.UsedAs<T>
type Signal<T...> = Signal.Signal<T...>
type ButtonState = Button.ButtonState

type ButtonStyles = "PRIMARY" | "TITLE"

local Styles: {
	[ButtonStyles]: {[string]: (any) -> Color3}
} = {
	["PRIMARY"] = {
		BackgroundColor3 = function(state: ButtonState): Color3
			if state.clicked() then
				return Themes.colors.Primary():Lerp(Themes.colors.Text(), 0.3)
			elseif state.hovered() then
				return Themes.colors.Primary():Lerp(Themes.colors.Text(), 0.15)
			end

			return Themes.colors.Primary()
		end,
		TextColor3 = Themes.colors.Text,
	},
	["TITLE"] = {
		BackgroundColor3 = function(state: ButtonState): Color3
			if state.clicked() then
				return Themes.colors.Secondary():Lerp(Themes.colors.Text(), 0.3)
			elseif state.hovered() then
				return Themes.colors.Primary()
			end

			return Themes.colors.Secondary()
		end,
		TextColor3 = Themes.colors.Text,
	},
}

return function(props: {
	Style: ButtonStyles,

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

	Disabled: Source<boolean>?,

	State: ButtonState?,

	OnClick: Signal<>?,
	OnEnter: Signal<>?,
	OnLeave: Signal<>?,
	OnDown: Signal<>?,
	OnUp: Signal<>?,
})
	local state = props.State or {
		hovered = source(false),
		clicked = source(false)
	}
	local style = Styles[props.Style]

	return Button {
		Name = props.Name,

		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,

		SizeConstraint = props.SizeConstraint,
		AutomaticSize = props.AutomaticSize,

		BackgroundColor3 = tween(function()
			return style.BackgroundColor3(state)
		end, Design.BUTTON.TRANSITION.TWEEN_INFO),

		Font = props.Font,
		Text = props.Text,
		TextSize = props.TextSize,
		TextColor3 = tween(function()
			return style.TextColor3(state)
		end, Design.BUTTON.TRANSITION.TWEEN_INFO),

		Disabled = props.Disabled,

		State = state,

		OnClick = props.OnClick,
		OnEnter = props.OnEnter,
		OnLeave = props.OnLeave,
		OnDown = props.OnDown,
		OnUp = props.OnUp
	}
end
