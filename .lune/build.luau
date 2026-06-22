local process = require("@lune/process")
local fs = require("@lune/fs")
local arguments = require("./lib/arguments")
local installer = require("./lib/installer")
local constants = require("./lib/constants")

type Options = {
	read skip_plugin: boolean,
}

local RELEASE_DIR = constants.RELEASE_DIR
local RELEASE_PATH = constants.RELEASE_PATH

local function build()
	if not fs.isDir(RELEASE_DIR) then fs.writeDir(RELEASE_DIR) end

	local result = process.exec("rojo", { "build", "-o", RELEASE_PATH })
	assert(result.ok, result.stderr)
end

local function init(options: Options)
	local clock = os.clock()

	build()
	if not options.skip_plugin then installer.install() end

	print(string.format("build completed in %.2fs", os.clock() - clock))
end

init(arguments.assert("usage: lune run build [-s|--skip-plugin]", {
	skip_plugin = arguments.flag("-s", "--skip-plugin"),
}))
