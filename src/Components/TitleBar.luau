--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Design = require(PluginRoot.Shared.Design)
local Themes = require(PluginRoot.Shared.Themes)
local Signal = require(PluginRoot.Utility.Signal)

local fluid = require(PluginRoot.Packages.fluid)
local create = fluid.create

local StyledButton = require(PluginRoot.Components.StyledButton)

type Signal<T...> = Signal.Signal<T...>

local function TitleButton(props: {
	Name: string,
	Index: number,

	Text: string,

	OnClick: Signal<>,
})
	return StyledButton {
		Style = "TITLE",

		Name = props.Name,

		LayoutOrder = props.Index,

		Size = UDim2.fromScale(1, 1),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		AutomaticSize = Enum.AutomaticSize.None,

		Font = Design.TITLE_BAR.BUTTON.TEXT_FONT,
		Text = props.Text,
		TextSize = Design.TITLE_BAR.BUTTON.TEXT_SIZE,

		OnClick = props.OnClick
	}
end

return function(props: {
	RequestClose: Signal<>,
	RequestMinimize: Signal<>?,
})
	return create("Frame") {
		Name = "TitleBar",

		BackgroundTransparency = 1,
		BorderSizePixel = 0,

		Size = UDim2.new(1, 0, 0, Design.TITLE_BAR.HEIGHT),

		create("Frame") {
			Name = "Buttons",

			Size = UDim2.fromScale(1, 1),

			BackgroundColor3 = Themes.colors.Secondary,
			BorderSizePixel = 0,

			TitleButton {
				Name = "Close",
				Index = 1,

				Text = "X",

				OnClick = props.RequestClose
			},
			if props.RequestMinimize then
				TitleButton {
					Name = "Minimize",
					Index = 0,

					Text = "\u{2014}",

					OnClick = props.RequestMinimize
				}
			else nil,

			create("UIListLayout") {
				Padding = UDim.new(0, Design.TITLE_BAR.BUTTON.PADDING),

				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,

				HorizontalAlignment = Enum.HorizontalAlignment.Right,
			},
		}
	}
end
