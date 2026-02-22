--!strict

export type function props(component: type): type
	assert(component:is("function"), "not a function")
	local parameters = component:parameters()
	local props = parameters.head and parameters.head[1]
	assert(props and props:is("table"), "not a component function")
	return props
end

return nil
