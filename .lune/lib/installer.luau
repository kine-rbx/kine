const fs = require("@lune/fs")
const constants = require("./constants")

const RELEASE_PATH = constants.RELEASE_PATH
const INSTALL_PATH = constants.INSTALL_PATH

const installer = {}

function installer.install()
	assert(fs.isFile(RELEASE_PATH), `release file not found at {RELEASE_PATH}`)

	const data = fs.readFile(RELEASE_PATH)
	fs.writeFile(INSTALL_PATH, data)

	print(`successfully installed plugin to {INSTALL_PATH}`)
end

function installer.uninstall()
	if fs.isFile(INSTALL_PATH) then
		fs.removeFile(INSTALL_PATH)
		print("successfully uninstalled plugin")
	else
		print(`no plugin found at {INSTALL_PATH}, nothing to uninstall`)
	end
end

return installer
