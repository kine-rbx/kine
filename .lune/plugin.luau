const args = require("./lib/args")
const installer = require("./lib/installer")

type Options = {
	read option: "install" | "uninstall",
}

const function init(options: Options)
	if options.option == "install" then
		installer.install()
	elseif options.option == "uninstall" then
		installer.uninstall()
	end
end

init(args.assert("usage: lune run plugin <install|uninstall>", {
	option = args.required_positional("install" :: "install", "uninstall" :: "uninstall"),
}))
