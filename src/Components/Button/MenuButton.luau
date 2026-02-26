--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Signal = require(PluginRoot.Common.Signal)

local fluid = require(PluginRoot.Packages.fluid)

local Button = require(PluginRoot.Components.Button)
local Dropdown = require(PluginRoot.Components.Dropdown)

local TokensMenuButton = require(PluginRoot.Tokens.Button.MenuButton)

type Signal<T...> = Signal.Signal<T...>
type Source<T> = fluid.Source<T>
type UsedAs<T> = fluid.UsedAs<T>
type DropdownDirection = Dropdown.DropdownDirection
type Dropdown = Dropdown.Dropdown

return function(props: {
	Disabled: Source<boolean>?,

	DropdownDirection: DropdownDirection?,
	Dropdown: Dropdown?,

	Text: UsedAs<string>?,

	IconLeft: UsedAs<string>?,
	IconRight: UsedAs<string>?,

	Size: ("Small" | "Medium" | "Large" | vector)?,

	Name: UsedAs<string>?,

	LayoutOrder: UsedAs<number>?,
})
	local OnDown = Signal.new()
	OnDown:connect(function()
		if not fluid.read(props.Disabled) then
			Dropdown(props.Dropdown, props.DropdownDirection)
		end
	end)

	local OnEnter = Signal.new()
	OnEnter:connect(function() end)

	return Button {
		Disabled = props.Disabled,

		Text = props.Text,

		IconLeft = props.IconLeft,
		IconRight = props.IconRight,

		Variant = TokensMenuButton.VARIANT,
		Colors = TokensMenuButton.COLORS,
		Size = props.Size,
		Padding = TokensMenuButton.PADDING,

		Name = props.Name or fluid.read(props.Text),

		LayoutOrder = props.LayoutOrder,

		OnDown = OnDown,
		OnEnter = OnEnter,
	}
end
