--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Theme = require(PluginRoot.Shared.Theme)
local Signal = require(PluginRoot.Common.Signal)

local fluid = require(PluginRoot.Packages.fluid)

local TitleButton = require(PluginRoot.Components.Button.TitleButton)

local TokensTitleBar = require(PluginRoot.Tokens.TitleBar)

type Signal<T...> = Signal.Signal<T...>
type UsedAs<T> = fluid.UsedAs<T>

return function(props: {
	Title: UsedAs<string>,

	OnClose: Signal<>,
	OnMinimize: Signal<>?,
})
	return fluid.create("Frame") {
		Name = "TitleBar",

		LayoutOrder = 0,

		BackgroundColor3 = TokensTitleBar.COLOR,
		BorderSizePixel = 0,

		Size = UDim2.new(1, 0, 0, TokensTitleBar.HEIGHT),

		fluid.create("Frame") {
			Name = "Buttons",

			Size = UDim2.fromScale(1, 1),

			BackgroundTransparency = 1,
			BorderSizePixel = 0,

			TitleButton {
				Type = "Close",

				LayoutOrder = 1,

				OnClick = props.OnClose
			},
			if props.OnMinimize then
				TitleButton {
					Type = "Minimize",

					LayoutOrder = 0,

					OnClick = props.OnMinimize
				}
			else nil,

			fluid.create("UIListLayout") {
				Padding = UDim.new(0, TokensTitleBar.SEPARATION),

				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,

				HorizontalAlignment = Enum.HorizontalAlignment.Right,
			},
		}
	}
end
