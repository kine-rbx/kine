--!strict
--!optimize 2

return table.freeze {
	UI_FOLDER_NAME = "KineUI",

	FONTS = {
		DEFAULT = Font.fromId(12187365364), -- Inter
	},

	WINDOW = {
		TRANSITION = {
			TIME = 0.2,
			SCALE = 1.1,
			OFFSET = 8,
		}
	}
}