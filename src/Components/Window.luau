--!strict
--!optimize 2

local PluginRoot = script:FindFirstAncestor("Kine")
local Config = require(PluginRoot.Shared.Config)

local fluid = require(PluginRoot.Packages.fluid)
local create, interval = fluid.create, fluid.interval

local TRANSITION = Config.WINDOW.TRANSITION

local function easeIn(t: number): number
	return t ^ 3
end

local function easeOut(t: number): number
	return 1 - (1 - t) ^ 3
end

return function(props: {
	position: () -> vector,
	size: () -> vector,
	open: () -> boolean
})
	-- TODO: fork fluid and add tweening, this is the worst thing ever

	local openElapsed = 0
	local closeElapsed = TRANSITION.TIME

	local scale = interval(function(deltaTime: number)
		if props.open() then
			openElapsed = math.min(openElapsed + deltaTime, TRANSITION.TIME)
			closeElapsed = TRANSITION.TIME - openElapsed
			return math.lerp(TRANSITION.SCALE, 1, easeOut(openElapsed / TRANSITION.TIME))
		else
			closeElapsed = math.min(closeElapsed + deltaTime, TRANSITION.TIME)
			return math.lerp(1, TRANSITION.SCALE, easeIn(closeElapsed / TRANSITION.TIME))
		end
	end, 240)

	local transparency = interval(function(deltaTime: number)
		if props.open() then
			return math.lerp(1, 0, easeOut(openElapsed / TRANSITION.TIME))
		else
			return math.lerp(0, 1, easeIn(closeElapsed / TRANSITION.TIME))
		end
	end, 240)

	local position = interval(function(deltaTime: number)
		local target = props.position()
		if props.open() then
			return UDim2.fromOffset(target.x, target.y)
		else
			local offset = math.lerp(0, TRANSITION.OFFSET, closeElapsed / TRANSITION.TIME)
			return UDim2.fromOffset(target.x, target.y + offset)
		end
	end, 240)

	return create("CanvasGroup") {
		Name = "Window",
		AnchorPoint = Vector2.new(0.5, 0.5),

		GroupTransparency = transparency,

		Position = position,
		Size = function()
			local size = props.size()
			return UDim2.fromOffset(size.x, size.y)
		end,

		create("UIScale") {
			Scale = scale
		}
	}
end