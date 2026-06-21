const process = require("@lune/process")
const fs = require("@lune/fs")
const args = require("./lib/args")
const installer = require("./lib/installer")
const constants = require("./lib/constants")

type Options = {
	read skip_plugin: boolean,
}

const RELEASE_DIR = constants.RELEASE_DIR
const RELEASE_PATH = constants.RELEASE_PATH

const function build()
	if not fs.isDir(RELEASE_DIR) then fs.writeDir(RELEASE_DIR) end

	const result = process.exec("rojo", { "build", "-o", RELEASE_PATH })
	assert(result.ok, result.stderr)
end

const function init(options: Options)
	const clock = os.clock()

	build()
	if not options.skip_plugin then installer.install() end

	print(string.format("build completed in %.2fs", os.clock() - clock))
end

init(args.assert("usage: lune run build [-s|--skip-plugin]", {
	skip_plugin = args.flag("-s", "--skip-plugin"),
}))
