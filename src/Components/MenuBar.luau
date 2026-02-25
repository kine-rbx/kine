--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Theme = require(PluginRoot.Shared.Theme)
local Signal = require(PluginRoot.Common.Signal)

local fluid = require(PluginRoot.Packages.fluid)

local MenuButton = require(PluginRoot.Components.Button.MenuButton)
local Dropdown = require(PluginRoot.Components.Dropdown)
local Padding = require(PluginRoot.Components.Decorators.Padding)

local MenuBarTokens = require(PluginRoot.Tokens.MenuBar)

type Signal<T...> = Signal.Signal<T...>
type UsedAs<T> = fluid.UsedAs<T>
type Dropdown = Dropdown.Dropdown

export type MenuItem = {
	Text: UsedAs<string>?,
	Icon: UsedAs<string>?,
	Dropdown: Dropdown?
}

return function(props: {
	Items: {MenuItem}
})
	local container = fluid.create("Frame") {
		Name = "Buttons",

		Size = UDim2.fromScale(1, 1),

		BackgroundTransparency = 1,
		BorderSizePixel = 0,

		Padding(MenuBarTokens.PADDING),

		fluid.create("UIListLayout") {
			Padding = UDim.new(0, MenuBarTokens.SEPARATION),

			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,

			HorizontalAlignment = Enum.HorizontalAlignment.Left,
		},
	}

	local function buttons(): {Frame}
		return fluid.for_values(props.Items, function(item, index)
			return MenuButton {
				DropdownDirection = "Bottom",
				Dropdown = item.Dropdown,

				Text = item.Text,
				Icon = item.Icon,

				LayoutOrder = index(),
			}
		end)()
	end

	fluid.mount(buttons, container)

	return fluid.create("Frame") {
		Name = "MenuBar",

		LayoutOrder = 1,

		BackgroundColor3 = Theme.colors.Primary,
		BorderSizePixel = 0,

		Size = UDim2.new(1, 0, 0, MenuBarTokens.HEIGHT),

		container
	}
end
