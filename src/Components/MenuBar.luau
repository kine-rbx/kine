--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Design = require(PluginRoot.Shared.Design)
local Themes = require(PluginRoot.Shared.Themes)
local Signal = require(PluginRoot.Utility.Signal)

local fluid = require(PluginRoot.Packages.fluid)
local create, mount = fluid.create, fluid.mount

local StyledButton = require(PluginRoot.Components.StyledButton)
local Dropdown = require(PluginRoot.Components.Dropdown)
local Margin = require(PluginRoot.Components.Decorators.Margin)

type Signal<T...> = Signal.Signal<T...>
type Dropdown = Dropdown.Dropdown

export type MenuItem = {
	Text: string,
	Dropdown: Dropdown?
}

local function MenuButton(props: {
	Text: string,
	Index: number,

	Dropdown: Dropdown?
})
	local onDown: Signal<>?
	if props.Dropdown then
		local dropdown = Dropdown(props.Dropdown)
		onDown = Signal.new()
		onDown:connect(dropdown)
	end

	return StyledButton {
		Style = "Primary",

		Name = props.Text,

		LayoutOrder = props.Index,

		Size = UDim2.fromScale(0, 1),

		Font = Design.MENU_BAR.BUTTON.TEXT_FONT,
		Text = props.Text,

		TextSize = Design.MENU_BAR.BUTTON.TEXT_SIZE,
		TextMargin = Design.MENU_BAR.BUTTON.TEXT_MARGIN,

		OnDown = onDown
	}
end

return function(items: {MenuItem})
	local container = create("Frame") {
		Name = "Buttons",

		Size = UDim2.fromScale(1, 1),

		BackgroundTransparency = 1,
		BorderSizePixel = 0,

		create("UIListLayout") {
			Padding = UDim.new(0, Design.MENU_BAR.BUTTON.PADDING),

			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,

			HorizontalAlignment = Enum.HorizontalAlignment.Left,
		},
		Margin(Design.MENU_BAR.MARGIN)
	}

	local function buttons(): {ImageButton}
		return fluid.for_values(items, function(item, index)
			return MenuButton {
				Text = item.Text,
				Index = index(),

				Dropdown = item.Dropdown
			}
		end)()
	end

	mount(buttons, container)

	return create("Frame") {
		Name = "MenuBar",

		LayoutOrder = 1,

		BackgroundColor3 = Themes.colors.Primary,
		BorderSizePixel = 0,

		Size = UDim2.new(1, 0, 0, Design.MENU_BAR.HEIGHT),

		container
	}
end
