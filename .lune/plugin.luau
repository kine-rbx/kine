local process = require("@lune/process")
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")

local STUDIO_PLUGIN_PATH = roblox.studioPluginPath():gsub("\\", "/")

local RELEASE_DIR = "release"
local PLUGIN_RELEASE_PATH = `{RELEASE_DIR}/Kine.rbxm`
local PLUGIN_INSTALL_PATH = `{STUDIO_PLUGIN_PATH}/Kine.rbxm`

local function uninstall()
	if fs.isFile(PLUGIN_INSTALL_PATH) then
		fs.removeFile(PLUGIN_INSTALL_PATH)
		print("successfully uninstalled plugin")
	else
		print(`no plugin found at {PLUGIN_INSTALL_PATH}; nothing to uninstall`)
	end
end

local function install()
	assert(fs.isFile(PLUGIN_RELEASE_PATH), `release file not found at {PLUGIN_RELEASE_PATH}`)

	local data = fs.readFile(PLUGIN_RELEASE_PATH)
	fs.writeFile(PLUGIN_INSTALL_PATH, data)

	print(`successfully installed plugin to {PLUGIN_INSTALL_PATH}`)
end

if process.args[1] == "install" then
	install()
elseif process.args[1] == "uninstall" then
	uninstall()
else
	error("usage: lune run plugin <install|uninstall>")
end
