--!strict

const plugin_root = script:FindFirstAncestor("kine")
const scheduler = require(plugin_root.service.scheduler)

const fluid = require(plugin_root.packages.fluid)
const tween = require(plugin_root.fluid.tween)

export type UsedAs<T> = fluid.UsedAs<T>
export type Source<T> = fluid.Source<T>
export type Action = fluid.Action
export type PropertiesFor<T> = fluid.PropertiesFor<T>

(fluid :: typeof(fluid) & { tween: typeof(tween) }).tween = tween

const step = fluid.provide_scheduler()
scheduler.on("REACT", function(delta_time)
	step(delta_time)
	tween.step(delta_time)
end)

return fluid
