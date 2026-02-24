--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Signal = require(PluginRoot.Common.Signal)

local fluid = require(PluginRoot.Packages.fluid)

local Button = require(PluginRoot.Components.Button)

local TokensTitleButton = require(PluginRoot.Tokens.Button.TitleButton)

type Signal<T...> = Signal.Signal<T...>
type Source<T> = fluid.Source<T>
type UsedAs<T> = fluid.UsedAs<T>

return function(props: {
	Type: "Close" | "Minimize",

	LayoutOrder: UsedAs<number>?,

	OnClick: Signal<>?,
})
	return Button {
		Text = props.Type == "Close" and TokensTitleButton.TEXT["CLOSE"] or TokensTitleButton.TEXT["MINIMIZE"],

		Variant = TokensTitleButton.VARIANT,
		Color = props.Type == "Close" and TokensTitleButton.COLOR["CLOSE"] or TokensTitleButton.COLOR["MINIMIZE"],
		Size = TokensTitleButton.SIZE,

		Name = props.Type,

		LayoutOrder = props.LayoutOrder,

		OnClick = props.OnClick,
	}
end
