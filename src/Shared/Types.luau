--!strict

export type function properties(component: type): type
	assert(component:is("function"), "not a function")
	local parameters = component:parameters()
	return parameters.head and parameters.head[1] or types.singleton(nil)
end
