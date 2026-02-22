--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local deepFreeze = require(PluginRoot.Helpers.deepFreeze)

return deepFreeze {
	TEXT_FONTS = {
		["DEFAULT"] = Font.fromId(12187365364), -- Inter
		["MICHROMA"] = Font.fromEnum(Enum.Font.Michroma), -- Michroma
	},
	TEXT_SIZES = {
		["SMALL"] = 10,
		["MEDIUM"] = 12,
		["LARGE"] = 16,
	},
	ROUNDING = {
		["SMALL"] = 3,
		["MEDIUM"] = 6,
		["LARGE"] = 9,
	},
	PADDING = {
		["SMALL"] = 2,
		["MEDIUM"] = 4,
		["LARGE"] = 8,
	},
	TIMING = {
		["VERY_FAST"] = 0.050,
		["FAST"] = 0.100,
		["MEDIUM"] = 0.200,
		["SLOW"] = 0.300,
		["VERY_SLOW"] = 0.500,
	},
	FADE = 0.3,
}
