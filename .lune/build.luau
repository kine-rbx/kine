local process = require("@lune/process")
local fs = require("@lune/fs")

local RELEASE_DIR = "release"

local function build(): ()
	fs.writeDir(RELEASE_DIR)

	local result = process.exec("rojo", {
		"build", "--output", `{RELEASE_DIR}/Kine.rbxm`
	})
	assert(result.ok, result.stderr)
end

local clock = os.clock()
build()
print(string.format("build completed in %.2fs", os.clock() - clock))

if table.find(process.args, "--install-plugin") or table.find(process.args, "-p") then
	local result = process.exec("lune", {
		"run", "plugin", "install"
	})
	assert(result.ok, result.stderr)
end