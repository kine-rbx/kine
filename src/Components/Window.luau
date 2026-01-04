--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Design = require(PluginRoot.Shared.Design)
local Themes = require(PluginRoot.Shared.Themes)

local fluid = require(PluginRoot.Packages.fluid)
local source, effect, create, tween = fluid.source, fluid.effect, fluid.create, fluid.tween

local Border = require(PluginRoot.Components.Decorators.Border)

type Source<T> = fluid.Source<T>

local TRANSITION = Design.WINDOW.TRANSITION

return function(props: {
	Open: Source<boolean>,

	Position: Source<vector>,
	Size: Source<vector>,
})
	local open = source(false)

	local scale, scaleControls = tween(function()
		return open() and 1 or TRANSITION.SCALE
	end, TRANSITION.TWEEN_INFO["IN"])

	local transparency, transparencyControls = tween(function()
		return open() and 0 or 1
	end, TRANSITION.TWEEN_INFO["IN"])

	open(true)

	local position, positionControls = tween(function()
		local target = props.Position()
		if open() then
			return UDim2.fromOffset(target.x, target.y)
		else
			return UDim2.fromOffset(target.x, target.y + TRANSITION.OFFSET)
		end
	end, TRANSITION.TWEEN_INFO["IN"])

	effect(function()
		open(props.Open())
		if not open() then
			scaleControls({tween_info = TRANSITION.TWEEN_INFO["OUT"]})
			transparencyControls({tween_info = TRANSITION.TWEEN_INFO["OUT"]})
			positionControls({tween_info = TRANSITION.TWEEN_INFO["OUT_POSITION"]})
		end
	end)

	return create("CanvasGroup") {
		Name = "Window",

		Active = true,

		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = position,
		Size = function()
			local target = props.Size()
			return UDim2.fromOffset(target.x, target.y)
		end,

		BackgroundColor3 = Themes.colors.Background,
		BackgroundTransparency = Design.WINDOW.TRANSPARENCY,
		BorderSizePixel = 0,

		GroupTransparency = transparency,

		create("UIScale") {
			Scale = scale
		},
		create("UICorner") {
			CornerRadius = UDim.new(0, Design.WINDOW.ROUNDING)
		},
		Border()
	}
end
