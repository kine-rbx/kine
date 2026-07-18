--!strict

const plugin_root = script:FindFirstAncestor("kine")
const fluid = require(plugin_root.fluid)
const scheduler = require(plugin_root.services.scheduler)

export type MouseBindings = {
	read on_enter: (() -> ())?,
	read on_leave: (() -> ())?,
}

export type InstanceBinding = {
	read active: fluid.Source<boolean>?,

	read bindings: MouseBindings,
}

const input = {}

function input.bind(binding: InstanceBinding): (Instance) -> () -> ()
	return function(instance)
		return fluid.root(function()
			print(`bound {instance.Name}`)
			fluid.cleanup(function()
				print(`unbound {instance.Name}`)
			end)
		end)
	end
end

do
	scheduler.on("INPUT", function(delta_time)
		-- TODO
	end)
end

return input
