--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local deepFreeze = require(PluginRoot.Helpers.deepFreeze)

local TokensGlobal = require(PluginRoot.Tokens.Global)

return deepFreeze {
	ROUNDING = TokensGlobal.ROUNDING["MEDIUM"],
	TRANSLUCENCY = 0.2,
	COLORS = {
		FOCUSED = Color3.new(1, 1, 1),
		UNFOCUSED = Color3.new(0.4, 0.4, 0.4),
	},
	TRANSITION = {
		TIME = 0.18,
		SCALE = 1.1,
		OFFSET = 10,
		TWEEN_INFO = {
			["IN"] = TweenInfo.new(0.18, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
			["OUT"] = TweenInfo.new(0.16, Enum.EasingStyle.Cubic, Enum.EasingDirection.In),
			["OUT_POSITION"] = TweenInfo.new(0.16, Enum.EasingStyle.Linear),
			["FOCUS"] = TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
		},
	},
}
