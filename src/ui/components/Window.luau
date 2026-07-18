--!strict

const plugin_root = script:FindFirstAncestor("kine")
const fluid = require(plugin_root.fluid)
const context_types = require(plugin_root.contexts.context_types)

const create_animated_container = function(context: context_types.WindowContext): CanvasGroup | Frame
	print(context.animating())
	if context.animating() then
		return fluid.create("CanvasGroup") {
			Name = "AnimatedContainer",

			Size = UDim2.fromScale(1, 1),
		}
	else
		return fluid.create("Frame") {
			Name = "AnimatedContainer",

			Size = UDim2.fromScale(1, 1),
		}
	end
end

return function(props: {
	WindowContext: context_types.WindowContext,
}): Frame
	const context = props.WindowContext

	const container = fluid.create("Frame") { -- TODO: replace with panel
		Name = "Container",

		Size = UDim2.fromScale(1, 1),
	}
	context.container = container

	return fluid.create("Frame") {
		Name = context.id,

		ZIndex = context.index,

		Position = fluid.derive(function()
			const value = context.position()
			return UDim2.fromOffset(value.x, value.y)
		end),
		Size = fluid.derive(function()
			const value = context.size()
			return UDim2.fromOffset(value.x, value.y)
		end),

		BackgroundTransparency = 1,

		fluid.action(function(instance)
			local cleanup_animated_container: (() -> ())?

			fluid.effect(function()
				if cleanup_animated_container then cleanup_animated_container() end

				fluid.root(function(destroy)
					const animated_container = create_animated_container(context)
					container.Parent = animated_container
					animated_container.Parent = instance
					cleanup_animated_container = destroy

					fluid.cleanup(function()
						container.Parent = nil
						animated_container:Destroy()
					end)
				end)
			end)
		end),
	}
end
