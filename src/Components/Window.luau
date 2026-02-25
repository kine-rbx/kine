--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Control = require(PluginRoot.Shared.Control)
local Theme = require(PluginRoot.Shared.Theme)

local styleTweens = require(PluginRoot.Helpers.styleTweens)

local fluid = require(PluginRoot.Packages.fluid)

local TokensWindow = require(PluginRoot.Tokens.Window)

type Source<T> = fluid.Source<T>

type WindowVisualState = {
	read open: Source<boolean>,
	read focused: Source<boolean>,
	read position: Source<vector>,
}

return function(props: {
	Open: Source<boolean>,

	Position: Source<vector>,
	Size: Source<vector>,
})
	local state: WindowVisualState = {
		open = fluid.source(false),
		focused = fluid.source(true),
		position = props.Position
	}
	fluid.effect(function()
		state.open(props.Open())
	end)

	local tweenInfo = fluid.source(TokensWindow.TRANSITION.TWEEN_INFO["IN"])
	local tweenInfoPosition = fluid.source(TokensWindow.TRANSITION.TWEEN_INFO["IN"])

	local tweens = styleTweens {
		color = {
			callback = function()
				if state.focused() then
					return TokensWindow.COLORS.FOCUSED
				else
					return TokensWindow.COLORS.UNFOCUSED
				end
			end,
			tweenInfo = TokensWindow.TRANSITION.TWEEN_INFO["FOCUS"]
		},
		position = {
			callback = function()
				local target = state.position()
				if state.open() then
					return UDim2.fromOffset(target.x, target.y)
				else
					return UDim2.fromOffset(target.x, target.y + TokensWindow.TRANSITION.OFFSET)
				end
			end,
			tweenInfo = tweenInfoPosition
		},
		scale = {
			callback = function()
				return state.open() and 1 or TokensWindow.TRANSITION.SCALE
			end,
			tweenInfo = tweenInfo
		},
		transparency = {
			callback = function()
				return state.open() and 0 or 1
			end,
			tweenInfo = tweenInfo
		},
	}

	fluid.effect(function()
		local open = state.open()
		tweenInfo(open and TokensWindow.TRANSITION.TWEEN_INFO["IN"] or TokensWindow.TRANSITION.TWEEN_INFO["OUT"])
		tweenInfoPosition(open and TokensWindow.TRANSITION.TWEEN_INFO["IN"] or TokensWindow.TRANSITION.TWEEN_INFO["OUT_POSITION"])
	end)

	return fluid.create("CanvasGroup") {
		Name = "Window",

		Active = true,

		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = tweens.position,
		Size = function()
			local target = props.Size()
			return UDim2.fromOffset(target.x, target.y)
		end,

		BackgroundColor3 = Theme.colors.Background,
		BackgroundTransparency = TokensWindow.TRANSLUCENCY,
		BorderSizePixel = 0,

		GroupColor3 = tweens.color,
		GroupTransparency = tweens.transparency,

		fluid.create("UIScale") {
			Scale = tweens.scale
		},
		fluid.create("UICorner") {
			CornerRadius = UDim.new(0, TokensWindow.ROUNDING)
		},
		fluid.create("UIStroke") {
			Color = Theme.colors.Border
		},

		fluid.action(Control.registerWindow {
			focus = function()
				state.focused(true)
			end,
			unfocus = function()
				state.focused(false)
			end,
		}),
	}
end
