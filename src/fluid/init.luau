--!strict

const plugin_root = script:FindFirstAncestor("kine")
const scheduler = require(plugin_root.services.scheduler)

local fluid = require(plugin_root.packages.fluid)
const tween = require(plugin_root.fluid.tween)

fluid = fluid :: typeof(fluid) & {
	resolve_children: (props: { any }) -> { Instance },
	resolve_actions: (props: { any }) -> { fluid.Action },
	tween: typeof(tween.create),
}

export type UsedAs<T> = fluid.UsedAs<T>
export type Source<T> = fluid.Source<T>
export type Action = fluid.Action
export type PropertiesFor<T> = fluid.PropertiesFor<T>

do
	fluid.resolve_children = function(props: { any }): { Instance }
		const children: { Instance } = {}
		for _, value in props do
			if typeof(value) == "Instance" then table.insert(children, value) end
		end

		return children
	end

	fluid.resolve_actions = function(props: { any }): { fluid.Action }
		const actions: { fluid.Action } = {}
		for key, value in props do
			if type(key) == "number" and type(value) == "table" and fluid.is_action(value) then
				table.insert(actions, value)
			end
		end

		return actions
	end

	fluid.tween = tween.create

	const step = fluid.provide_scheduler()
	scheduler.on("REACT", function(delta_time)
		step(delta_time)
		tween.step(delta_time)
	end)
end

return fluid
