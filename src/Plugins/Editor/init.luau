--!strict
--!optimize 2

local PluginRoot = script:FindFirstAncestor("Kine")
local Config = require(script.Parent.Parent.Shared.Config)
local Plugin = require(PluginRoot.Shared.Plugin)

local fluid = require(PluginRoot.Packages.fluid)
local root, create, source, cleanup, mount = fluid.root, fluid.create, fluid.source, fluid.cleanup, fluid.mount

local Window = require(PluginRoot.Components.Window)

local activeGui: ScreenGui? = nil

local function setup(destroy: () -> ()): ()
	assert(activeGui)

	local window = {
		position = source(vector.create(512, 512)),
		size = source(vector.create(480, 256)),
		open = source(true)
	}

	local function ui(): {Instance}
		local frame = Window({
			position = window.position,
			size = window.size,
			open = window.open
		})

		return {frame}
	end

	mount(ui, activeGui)

	cleanup(function()
		window.open(false)
		task.wait(Config.WINDOW.TRANSITION.TIME)
		if activeGui then activeGui:Destroy() end
	end)
end

return function(uiFolder: Folder): ()
	local pluginButton = Plugin.buttons["Editor"]
	local destroy: () -> ()? = nil

	if activeGui then
		activeGui:Destroy()
		activeGui = nil
	end

	local connection = pluginButton.onClick:connect(function()
		if activeGui and activeGui.Parent then
			task.defer(pluginButton.reset, pluginButton)
			if destroy ~= nil then
				task.spawn(destroy)
				destroy = nil
			end
		else
			activeGui = create("ScreenGui") {
				Name = "Editor",
				Parent = uiFolder
			}
			if destroy then task.spawn(destroy) end
			destroy = root(setup)
		end
	end)

	cleanup(function()
		connection:disconnect()
	end)
end
