const process = require("@lune/process")

type Argument<Kind, Alias = string> = {
	read kind: Kind,
	read required: boolean,
	read aliases: { Alias },
}

type Positional<Alias> = Argument<"positional", Alias>
type Option = Argument<"option">
type Flag = Argument<"flag">
type Entry = Positional<any> | Option | Flag

type function map_returns(map: type): type
	assert(map:is("table"))

	const result = types.newtable()

	for key, property in map:properties() do
		const entry = property.read
		assert(entry and entry:is("table"))

		const kind = assert(entry:readproperty(types.singleton("kind"))):value()
		local value: type

		if kind == "flag" then
			value = types.boolean
		elseif kind == "option" then
			value = types.string
		elseif kind == "positional" then
			const aliases = entry:readproperty(types.singleton("aliases"))
			assert(aliases and aliases:is("table"))
			value = assert(aliases:readindexer()).result
		end

		assert(value)
		const required = entry:readproperty(types.singleton("required"))
		assert(required and required:is("boolean"))

		value = required and value or types.unionof(value, types.singleton(nil))
		result:setreadproperty(key, value)
		result:setwriteproperty(key, value)
	end

	return result
end

const args = {}

function args.required_positional<Alias>(...: Alias): Positional<Alias>
	return { kind = "positional", required = true, aliases = { ... } }
end
function args.optional_positional<Alias>(...: Alias): Positional<Alias>
	return { kind = "positional", required = false, aliases = { ... } }
end

function args.required_option(...: string): Option
	return { kind = "option", required = true, aliases = { ... } }
end
function args.optional_option(...: string): Option
	return { kind = "option", required = false, aliases = { ... } }
end

function args.flag(...: string): Flag
	return { kind = "flag", required = true, aliases = { ... } }
end

function args.assert<T>(on_error: string, map: T & { [any]: Entry }): map_returns<T>
	const result = {} :: { [string]: string | boolean }
	const alias_map: { [index<Entry, "kind">]: { [string]: string } } = {
		positional = {},
		option = {},
		flag = {},
	}

	for key, entry in map :: { [string]: Entry } do
		const target = alias_map[entry.kind]
		for _, alias in entry.aliases do
			target[alias] = key
		end
	end

	local index = 1
	while index <= #process.args do
		const alias = process.args[index]

		if alias_map.option[alias] then
			const key = alias_map.option[alias]
			index += 1
			const value = process.args[index]
			assert(value and alias_map.flag[value] == nil and alias_map.option[value] == nil, on_error)
			result[key] = value
		elseif alias_map.flag[alias] then
			result[alias_map.flag[alias]] = true
		elseif alias_map.positional[alias] then
			result[alias_map.positional[alias]] = alias
		end

		index += 1
	end

	for key, entry in map :: { [string]: Entry } do
		if entry.kind == "flag" then
			result[key] = result[key] or false
		elseif entry.kind == "positional" or entry.kind == "option" then
			assert(result[key] or not entry.required, on_error)
		end
	end

	return result :: any
end

return args
