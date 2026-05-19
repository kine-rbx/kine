--!strict

local plugin_root = script:FindFirstAncestor("kine")
local scheduler = require(plugin_root.service.scheduler)

local fluid = require(plugin_root.packages.fluid)
local tween = require(plugin_root.fluid.tween)

export type UsedAs<T> = fluid.UsedAs<T>
export type Source<T> = fluid.Source<T>
export type Action = fluid.Action
export type PropertiesFor<T> = fluid.PropertiesFor<T>

fluid = fluid :: typeof(fluid) & { tween: typeof(tween) }
fluid.tween = tween

local step = fluid.provide_scheduler()
scheduler.connect("react", function(delta_time)
	step(delta_time)
	tween.step(delta_time)
end)

return fluid
