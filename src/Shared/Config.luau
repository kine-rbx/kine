--!strict
--!optimize 2

return table.freeze {
	UI_FOLDER_NAME = "KineUI",
	FONTS = {
		DEFAULT = Font.fromId(12187365364), -- Inter
	},
	WINDOW = {
		TRANSITION = {
			TIME = 0.18,
			SCALE = 1.1,
			OFFSET = 10,
			TWEEN_INFO = {
				IN = TweenInfo.new(0.18, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
				OUT = TweenInfo.new(0.16, Enum.EasingStyle.Cubic, Enum.EasingDirection.In),
				OUT_POSITION = TweenInfo.new(0.16, Enum.EasingStyle.Linear),
			}
		}
	}
}
