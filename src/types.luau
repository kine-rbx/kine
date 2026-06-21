--!strict

local plugin_root = script:FindFirstAncestor("kine")

type function children_names(t: type): type
	assert(t:is("extern"))

	local union: type? = nil

	for key, property in t:properties() do
		const name = key:value()
		const read = property.read
		if name ~= "Parent" and read and read:is("extern") then
			union = union and types.unionof(union, types.singleton(name)) or types.singleton(name)
		end
	end

	return union or types.singleton(nil)
end

export type ToolKey = children_names<typeof(plugin_root.tools)>

return nil
