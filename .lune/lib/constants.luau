const roblox = require("@lune/roblox")

const STUDIO_PLUGIN_PATH = roblox.studioPluginPath():gsub("\\", "/")
const RELEASE_DIR = "release"
const RELEASE_NAME = "Kine.rbxm"

return {
	RELEASE_DIR = RELEASE_DIR,
	RELEASE_NAME = RELEASE_NAME,
	RELEASE_PATH = `{RELEASE_DIR}/{RELEASE_NAME}`,
	INSTALL_PATH = `{STUDIO_PLUGIN_PATH}/{RELEASE_NAME}`,
}
