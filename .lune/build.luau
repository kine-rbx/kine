local process = require("@lune/process")
local fs = require("@lune/fs")
local options = require("./options")

local RELEASE_DIR = "release"
local PLUGIN_RELEASE_PATH = `{RELEASE_DIR}/Kine.rbxm`

local function build(): ()
	fs.writeDir(RELEASE_DIR)

	local result = process.exec("rojo", {
		"build", "--output", PLUGIN_RELEASE_PATH
	})
	assert(result.ok, result.stderr)
end

local clock = os.clock()

build()

if not options("skip-plugin") then
	local result = process.exec("lune", {
		"run", "plugin", "install"
	})
	assert(result.ok, result.stderr)
end

print(string.format("build completed in %.2fs", os.clock() - clock))
