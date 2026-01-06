--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Design = require(PluginRoot.Shared.Design)
local Signal = require(PluginRoot.Common.Signal)

local fluid = require(PluginRoot.Packages.fluid)
local effect, create = fluid.effect, fluid.create

local Margin = require(PluginRoot.Components.Decorators.Margin)

type Source<T> = fluid.Source<T>
type UsedAs<T> = fluid.UsedAs<T>
type Signal<T...> = Signal.Signal<T...>

export type ButtonState = {
	read hovered: Source<boolean>,
	read clicked: Source<boolean>
}

return function(props: {
	Name: UsedAs<string>?,

	ZIndex: UsedAs<number>?,
	LayoutOrder: UsedAs<number>?,

	AnchorPoint: UsedAs<Vector2>?,
	Position: UsedAs<UDim2>?,
	Size: UsedAs<UDim2>?,

	SizeConstraint: UsedAs<Enum.SizeConstraint>?,
	AutomaticSize: UsedAs<Enum.AutomaticSize>?,

	BackgroundColor3: UsedAs<Color3>?,

	Font: UsedAs<Font>?,
	Text: UsedAs<string>?,

	TextSize: UsedAs<number>?,
	TextColor3: UsedAs<Color3>?,
	TextMargin: vector?,
	TextBounds: UsedAs<UDim2>?,

	Disabled: Source<boolean>?,

	State: ButtonState?,

	OnClick: Signal<>?,
	OnEnter: Signal<>?,
	OnLeave: Signal<>?,
	OnDown: Signal<>?,
	OnUp: Signal<>?,
})
	local state = props.State
	if state then
		state.hovered(false)
		state.clicked(false)
	end

	if props.Disabled and state then
		effect(function()
			if props.Disabled() then
				state.hovered(false)
				state.clicked(false)
			end
		end)
	end

	local function guard(callback: (...any) -> ()): (...any) -> ()
		return function(...: any)
			if not props.Disabled or not props.Disabled() then
				callback(...)
			end
		end
	end

	return create("ImageButton") {
		Name = props.Name or "Button",

		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size or UDim2.fromOffset(Design.BUTTON.SIZE_DEFAULT.x, Design.BUTTON.SIZE_DEFAULT.y),

		SizeConstraint = props.SizeConstraint or Enum.SizeConstraint.RelativeXY,
		AutomaticSize = props.AutomaticSize or Enum.AutomaticSize.X,
		AutoButtonColor = false,

		BackgroundColor3 = props.BackgroundColor3,
		BorderSizePixel = 0,

		MouseButton1Click = props.OnClick and guard(function()
			props.OnClick:fire()
		end),
		MouseEnter = (state or props.OnLeave) and guard(function()
			if state then state.hovered(true) end
			if props.OnEnter then props.OnEnter:fire() end
		end),
		MouseLeave = (state or props.OnLeave) and guard(function()
			if state then state.hovered(false) end
			if props.OnLeave then props.OnLeave:fire() end
		end),
		MouseButton1Down = (state or props.OnDown) and guard(function()
			if state then state.clicked(true) end
			if props.OnDown then props.OnDown:fire() end
		end),
		MouseButton1Up = (state or props.OnUp) and guard(function()
			if state then state.clicked(false) end
			if props.OnUp then props.OnUp:fire() end
		end),

		Margin(props.TextMargin or Design.BUTTON.TEXT_MARGIN),

		if props.Text then
			create("TextLabel") {
				Name = "Text",

				Interactable = false,

				Size = props.TextBounds or UDim2.fromScale(0, 1),

				AutomaticSize = Enum.AutomaticSize.X,

				BackgroundTransparency = 1,

				FontFace = props.Font or Design.FONTS["DEFAULT"],
				Text = props.Text,
				TextSize = props.TextSize or Design.TEXT_SIZES["BODY"],
				TextColor3 = props.TextColor3
			}
		else nil
	}
end
