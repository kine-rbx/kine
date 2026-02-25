--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local fluid = require(PluginRoot.Packages.fluid)

type function deepfreeze(t: type): type
	assert(t:is("table"), "must be a table")

	local function freeze(tt: type): type
		if tt:is("table") then
			for key, property in tt:properties() do
				if property.write then tt:setwriteproperty(key, nil) end
				if property.read then tt:setreadproperty(key, freeze(property.read)) end
			end

			return tt
		end

		return tt
	end

	return freeze(t)
end

local function deepFreeze<T>(t: T): deepfreeze<T>
	if not table.isfrozen(t) then
		table.freeze(t)
		for _, tt in t do
			if type(tt) == "table" then deepFreeze(tt) end
		end
	end

	return t
end

return function<T>(callback: () -> T): deepfreeze<T>
	local t: deepfreeze<T>
	fluid.root(function()
		t = deepFreeze(callback())
	end)

	return t
end
