local roblox = require("@lune/roblox")

local STUDIO_PLUGIN_PATH = roblox.studioPluginPath():gsub("\\", "/")
local RELEASE_DIR = "release"
local RELEASE_NAME = "Kine.rbxm"

return {
	RELEASE_DIR = RELEASE_DIR,
	RELEASE_NAME = RELEASE_NAME,
	RELEASE_PATH = `{RELEASE_DIR}/{RELEASE_NAME}`,
	INSTALL_PATH = `{STUDIO_PLUGIN_PATH}/{RELEASE_NAME}`,
}
