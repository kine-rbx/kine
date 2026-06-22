local args = require("./lib/args")
local installer = require("./lib/installer")

type Options = {
	read option: "install" | "uninstall",
}

local function init(options: Options)
	if options.option == "install" then
		installer.install()
	elseif options.option == "uninstall" then
		installer.uninstall()
	end
end

init(args.assert("usage: lune run plugin <install|uninstall>", {
	option = args.required_positional("install" :: "install", "uninstall" :: "uninstall"),
}))
