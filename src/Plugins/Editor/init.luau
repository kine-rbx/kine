--!strict
--!optimize 2

local PluginRoot = script:FindFirstAncestor("Kine")
local Design = require(PluginRoot.Shared.Design)
local Plugin = require(PluginRoot.Shared.Plugin)

local fluid = require(PluginRoot.Packages.fluid)
local root, create, source, cleanup, mount = fluid.root, fluid.create, fluid.source, fluid.cleanup, fluid.mount

local Window = require(PluginRoot.Components.Window)

local activeGui: ScreenGui? = nil

local function setup(destroy: () -> ()): ()
	assert(activeGui)

	local window = {
		position = source(vector.create(activeGui.AbsoluteSize.X, activeGui.AbsoluteSize.Y)),
		size = source(Design.WINDOWS["EDITOR"].DEFAULT_SIZE),
		open = source(true)
	}

	local function ui(): {Instance}
		local frame = Window {
			position = window.position,
			size = window.size,
			open = window.open
		}
		return {frame}
	end

	mount(ui, activeGui)

	cleanup(function()
		window.open(false)
		task.wait(Design.WINDOW_TRANSITION.TIME)
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
			pluginButton.reset()
			if destroy then task.spawn(destroy) end
			destroy = nil
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
