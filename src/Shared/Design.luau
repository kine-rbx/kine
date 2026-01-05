--!strict

local FONTS = table.freeze {
	["DEFAULT"] = Font.fromId(12187365364), -- Inter
	["MICHROMA"] = Font.fromEnum(Enum.Font.Michroma), -- Michroma
}
local ROUNDING = table.freeze {
	["SMALL"] = 3,
	["MEDIUM"] = 6,
	["LARGE"] = 9,
}
local PADDING = table.freeze {
	["SMALL"] = 2,
	["MEDIUM"] = 4,
	["LARGE"] = 8,
}
local TEXT_SIZES = table.freeze {
	["BODY"] = 12,
	["NOTE"] = 10,
}
return table.freeze {
	FONTS = FONTS,
	ROUNDING = ROUNDING,
	PADDING = PADDING,
	TEXT_SIZES = TEXT_SIZES,
	BUTTON = {
		SIZE_DEFAULT = vector.create(16, 12),
		MARGIN = vector.create(2, 2),
		TRANSITION = {
			TIME = 0.08,
			TWEEN_INFO = TweenInfo.new(0.08, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
		},
	},
	WINDOW = {
		TRANSPARENCY = 0.2,
		ROUNDING = ROUNDING["MEDIUM"],
		TRANSITION = {
			TIME = 0.18,
			SCALE = 1.1,
			OFFSET = 10,
			TWEEN_INFO = {
				["IN"] = TweenInfo.new(0.18, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
				["OUT"] = TweenInfo.new(0.16, Enum.EasingStyle.Cubic, Enum.EasingDirection.In),
				["OUT_POSITION"] = TweenInfo.new(0.16, Enum.EasingStyle.Linear),
			},
		},
	},
	WINDOWS = {
		["EDITOR"] = {
			TITLE = "Kine Editor",
			SIZE_DEFAULT = vector.create(500, 260),
			SIZE_MINIMUM = vector.create(240, 120),
		},
	},
	TITLE_BAR = {
		HEIGHT = 32,
		BUTTON = {
			TEXT_FONT = FONTS["MICHROMA"],
			TEXT_SIZE = 18,
			PADDING = 1,
		},
	},
	MENU_BAR = {
		HEIGHT = 22,
		MARGIN = vector.create(2, 2),
		BUTTON = {
			TEXT_FONT = FONTS["DEFAULT"],
			TEXT_SIZE = TEXT_SIZES["BODY"],
			PADDING = 1,
		},
	},
}
