--!strict

local FONTS = {
	["DEFAULT"] = Font.fromId(12187365364), -- Inter
	["MICHROMA"] = Font.fromEnum(Enum.Font.Michroma), -- Michroma
}

return table.freeze {
	TEXT_SIZE = {
		["BODY"] = 12,
		["NOTE"] = 10,
	},
	BUTTON = {
		DEFAULT_WIDTH = 16,
		DEFAULT_HEIGHT = 12,
	},
	WINDOW_TRANSITION = {
		TIME = 0.18,
		SCALE = 1.1,
		OFFSET = 10,
		TWEEN_INFO = {
			["IN"] = TweenInfo.new(0.18, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
			["OUT"] = TweenInfo.new(0.16, Enum.EasingStyle.Cubic, Enum.EasingDirection.In),
			["OUT_POSITION"] = TweenInfo.new(0.16, Enum.EasingStyle.Linear),
		},
	},
	WINDOWS = {
		["EDITOR"] = {
			TITLE = "Kine Editor",
			DEFAULT_SIZE = vector.create(500, 260),
			MINIMUM_SIZE = vector.create(240, 120),
		},
	},
	TITLE_BAR = {
		HEIGHT = 32,
		MARGIN = vector.create(6, 3),
		BUTTON = {
			TEXT_FONT = FONTS["MICHROMA"],
			TEXT_SIZE = 18,
		},
	},
	MENU_BAR = {
		HEIGHT = 22,
		MARGIN = vector.create(2, 2),
	},
}
