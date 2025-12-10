--!strict
--!optimize 2

local PluginRoot = script:FindFirstAncestor("Kine")
local Config = require(PluginRoot.Shared.Config)

local fluid = require(PluginRoot.Packages.fluid)
local create, effect, tween = fluid.create, fluid.effect, fluid.tween

local CONFIG_TRANSITION = Config.WINDOW.TRANSITION

return function(props: {
	position: () -> vector,
	size: () -> vector,
	open: () -> boolean
})
	props.open(false)

	local scale, scaleControls = tween(function()
		return props.open() and 1 or CONFIG_TRANSITION.SCALE
	end, CONFIG_TRANSITION.TWEEN_INFO.IN)

	local position, positionControls = tween(function()
		local target = props.position()
		if props.open() then
			return UDim2.fromOffset(target.x, target.y)
		else
			return UDim2.fromOffset(target.x, target.y + CONFIG_TRANSITION.OFFSET)
		end
	end, CONFIG_TRANSITION.TWEEN_INFO.IN)

	local transparency, transparencyControls = tween(function()
		return props.open() and 0 or 1
	end, CONFIG_TRANSITION.TWEEN_INFO.IN)

	props.open(true)

	effect(function()
		if not props.open() then
			scaleControls({tween_info = CONFIG_TRANSITION.TWEEN_INFO.OUT})
			positionControls({tween_info = CONFIG_TRANSITION.TWEEN_INFO.OUT_POSITION})
			transparencyControls({tween_info = CONFIG_TRANSITION.TWEEN_INFO.OUT})
		end
	end)

	return create("CanvasGroup") {
		Name = "Window",
		AnchorPoint = Vector2.new(0.5, 0.5),

		GroupTransparency = transparency,

		Position = position,
		Size = function()
			local target = props.size()
			return UDim2.fromOffset(target.x, target.y)
		end,

		create("UIScale") {
			Scale = scale
		}
	}
end
