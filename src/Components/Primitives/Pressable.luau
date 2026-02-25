--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Inputs = require(PluginRoot.Shared.Inputs)
local Signal = require(PluginRoot.Common.Signal)

local fluid = require(PluginRoot.Packages.fluid)

type Source<T> = fluid.Source<T>
type UsedAs<T> = fluid.UsedAs<T>
type Signal<T...> = Signal.Signal<T...>

export type PressableState = {
	read hovered: Source<boolean>,
	read clicked: Source<boolean>,
}

return function(props: {
	Disabled: Source<boolean>?,
	State: PressableState?,

	Size: UsedAs<UDim2>?,

	OnClick: Signal<>?,
	OnEnter: Signal<>?,
	OnLeave: Signal<>?,
	OnDown: Signal<>?,
	OnUp: Signal<>?,
})
	local state = props.State
	if state then
		state.hovered(false)
		state.clicked(false)
	end

	if props.Disabled and state then
		fluid.effect(function()
			if props.Disabled() then
				state.hovered(false)
				state.clicked(false)
			end
		end)
	end

	local function guard(callback: (...any) -> ()): (...any) -> ()
		return function(...: any)
			if not fluid.read(props.Disabled) then
				callback(...)
			end
		end
	end

	return fluid.create("Frame") {
		Name = "Pressable",

		Size = props.Size,

		BackgroundTransparency = 1,

		(props.OnClick) and fluid.action(Inputs.connectObject("LeftClick", guard(function()
			props.OnClick:fire()
		end)) :: (Instance) -> ()),

		(state or props.OnDown) and fluid.action(Inputs.connectObject("LeftDown", guard(function()
			if state then state.clicked(true) end
			if props.OnDown then props.OnDown:fire() end
		end)) :: (Instance) -> ()),

		(state or props.OnUp) and fluid.action(Inputs.connectObject("LeftUp", guard(function()
			if state then state.clicked(false) end
			if props.OnUp then props.OnUp:fire() end
		end)) :: (Instance) -> ()),

		(state or props.OnEnter) and fluid.action(Inputs.connectObject("Enter", guard(function()
			if state then state.hovered(true) end
			if props.OnEnter then props.OnEnter:fire() end
		end)) :: (Instance) -> ()),

		(state or props.OnLeave) and fluid.action(Inputs.connectObject("Leave", guard(function()
			if state then state.hovered(false) end
			if props.OnLeave then props.OnLeave:fire() end
		end)) :: (Instance) -> ())
	}
end
