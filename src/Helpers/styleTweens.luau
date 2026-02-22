--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local fluid = require(PluginRoot.Packages.fluid)

type Readable<T> = () -> T
type UsedAs<T> = fluid.UsedAs<T>

type Entry<T> = {
	callback: Readable<T>,
	tweenInfo: UsedAs<TweenInfo>
}

type function convert(t: type): type
	assert(t:is("table"), "must be a table")

	local tb = types.newtable()

	for key, tt in t:properties() do
		assert(tt.read and tt.read:is("table"), "invalid entry")

		for kk, property in tt.read:properties() do
			if kk:value() == "callback" then
				assert(property.read and property.read:is("function"), "invalid entry")

				local head = assert(property.read:returns().head, "invalid entry")
				local value = assert(head[1], "invalid entry")
				tb:setreadproperty(key, types.newfunction(nil, {head = {value}}))
			end
		end
	end

	return tb
end

return function<T>(config: T & {[any]: Entry<any>}): convert<T>
	local result = {}

	for key, entry in config :: {[any]: Entry<any>} do
		local callback = entry.callback
		local tweenInfo = entry.tweenInfo

		if type(tweenInfo) == "function" then
			local tween, controls = fluid.tween(callback, tweenInfo())
			fluid.effect(function()
				controls({tween_info = tweenInfo()})
			end)
			result[key] = tween
		else
			local tween = fluid.tween(callback, tweenInfo)
			result[key] = tween
		end
	end

	return result :: convert<T>
end
