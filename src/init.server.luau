--!strict

local CoreGui = game:GetService("CoreGui")

local PluginRoot = script
local Config = require(PluginRoot.Shared.Config)
local Plugin = require(PluginRoot.Shared.Plugin)

local fluid = require(PluginRoot.Packages.fluid)
local root, cleanup = fluid.root, fluid.cleanup

local plugins: {(uiFolder: Folder) -> ()} = {
	require(PluginRoot.Plugins.Editor)
}

local uiFolder: Folder

local function setup(): ()
	cleanup(function()
		if uiFolder.Parent ~= nil then uiFolder:Destroy() end
	end)

	for _, plugin in plugins do
		plugin(uiFolder)
	end
end

local destroy: () -> ()
local unloaded = false

local function initialize(): ()
	uiFolder = Instance.new("Folder")
	uiFolder.Name = Config.UI_FOLDER_NAME
	uiFolder.Parent = CoreGui
	uiFolder.AncestryChanged:Connect(function()
		if not unloaded then
			uiFolder.Parent = CoreGui
		end
	end)

	destroy = root(setup)

	local function reset()
		if not unloaded then
			destroy()
			initialize()
		end
	end

	uiFolder.Destroying:Once(function()
		task.defer(reset)
	end)
end

uiFolder = CoreGui:FindFirstChild(Config.UI_FOLDER_NAME) :: Folder
if uiFolder then uiFolder:Destroy() end

Plugin._initialize(plugin)
initialize()

plugin.Unloading:Once(function()
	unloaded = true
	destroy()
end)
