--!strict

local CoreGui = game:GetService("CoreGui")

local PluginRoot = script
local Config = require(PluginRoot.Shared.Config)

local fluid = require(PluginRoot.Packages.fluid)
local root, cleanup = fluid.root, fluid.cleanup

local unload: () -> ()
local unloaded = false

local function init(): ()
	local plugins: {ModuleScript} = {
		PluginRoot.Plugins.Editor
	}

	local uiFolder = CoreGui:FindFirstChild(Config.UI_FOLDER_NAME) :: Folder
	if uiFolder then uiFolder:Destroy() end

	local function setup(): ()
		cleanup(function()
			if uiFolder.Parent ~= nil then uiFolder:Destroy() end
		end)

		for _, module in plugins do
			local init = require(module) :: (uiFolder: Folder) -> ()
			init(uiFolder)
		end
	end

	uiFolder = Instance.new("Folder")
	uiFolder.Name = Config.UI_FOLDER_NAME
	uiFolder.Parent = CoreGui
	uiFolder.AncestryChanged:Connect(function()
		if not unloaded then
			uiFolder.Parent = CoreGui
		end
	end)

	local destroy = root(setup)

	local function reset()
		if not unloaded then
			destroy()
			init()
		end
	end

	uiFolder.Destroying:Once(function()
		task.defer(reset)
	end)
end

local function load(): ()
	require(PluginRoot.Shared.Plugin)._init(plugin)
	require(PluginRoot.Shared.Inputs)._init()
	require(PluginRoot.Shared.Themes)._init()
	init()
end

unload = root(load)

plugin.Unloading:Once(function()
	unloaded = true
	unload()
end)
