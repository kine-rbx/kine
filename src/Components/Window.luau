--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Design = require(PluginRoot.Shared.Design)
local Inputs = require(PluginRoot.Shared.Inputs)
local Themes = require(PluginRoot.Shared.Themes)

local fluid = require(PluginRoot.Packages.fluid)
local source, effect, create, action, tween = fluid.source, fluid.effect, fluid.create, fluid.action, fluid.tween

local Border = require(PluginRoot.Components.Decorators.Border)

type Source<T> = fluid.Source<T>

type WindowVisualState = {
	read open: Source<boolean>,
	read focused: Source<boolean>,
	read position: Source<vector>,
}

local TRANSITION = Design.WINDOW.TRANSITION

local function getTweens(state: WindowVisualState)
	state.open(false)

	local color = tween(function()
		if state.focused() then
			return Design.WINDOW.COLORS.FOCUSED
		else
			return Design.WINDOW.COLORS.UNFOCUSED
		end
	end, TRANSITION.TWEEN_INFO["FOCUS"])

	local scale, scaleControls = tween(function()
		return state.open() and 1 or TRANSITION.SCALE
	end, TRANSITION.TWEEN_INFO["IN"])

	local transparency, transparencyControls = tween(function()
		return state.open() and 0 or 1
	end, TRANSITION.TWEEN_INFO["IN"])

	state.open(true)

	local position, positionControls = tween(function()
		local target = state.position()
		if state.open() then
			return UDim2.fromOffset(target.x, target.y)
		else
			return UDim2.fromOffset(target.x, target.y + TRANSITION.OFFSET)
		end
	end, TRANSITION.TWEEN_INFO["IN"])

	effect(function()
		if not state.open() then
			scaleControls {tween_info = TRANSITION.TWEEN_INFO["OUT"]}
			transparencyControls {tween_info = TRANSITION.TWEEN_INFO["OUT"]}
			positionControls {tween_info = TRANSITION.TWEEN_INFO["OUT_POSITION"]}
		end
	end)

	return {
		color = color,
		scale = scale,
		transparency = transparency,
		position = position,
	}
end

return function(props: {
	Open: Source<boolean>,

	Position: Source<vector>,
	Size: Source<vector>,
})
	local state: WindowVisualState = {
		open = source(false),
		focused = source(true),
		position = props.Position
	}
	effect(function()
		state.open(props.Open())
	end)

	local tweens = getTweens(state)

	return create("CanvasGroup") {
		Name = "Window",

		Active = true,

		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = tweens.position,
		Size = function()
			local target = props.Size()
			return UDim2.fromOffset(target.x, target.y)
		end,

		BackgroundColor3 = Themes.colors.Background,
		BackgroundTransparency = Design.WINDOW.TRANSPARENCY,
		BorderSizePixel = 0,

		GroupColor3 = tweens.color,
		GroupTransparency = tweens.transparency,

		create("UIScale") {
			Scale = tweens.scale
		},
		create("UICorner") {
			CornerRadius = UDim.new(0, Design.WINDOW.ROUNDING)
		},
		Border(),

		action(Inputs.registerWindow({
			focus = function()
				state.focused(true)
			end,
			unfocus = function()
				state.focused(false)
			end,
		}) :: (Instance) -> ())
	}
end
