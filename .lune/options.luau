local process = require("@lune/process")

type Option =
	| "skip-plugin"

local OPTIONS: {[Option]: {string}} = {
	["skip-plugin"] = {"--skip-plugin", "-s"}
}

return function(name: Option): boolean
	local option = OPTIONS[name]
	for _, alias in option do
		if table.find(process.args, alias) then return true end
	end

	return false
end
