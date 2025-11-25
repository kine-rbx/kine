--!strict
--!optimize 2

local CoreGui = game:GetService("CoreGui")

local PluginRoot = script
local Plugin = require(PluginRoot.Shared.Plugin)

local fluid = require(PluginRoot.Packages.fluid)
local root, cleanup = fluid.root, fluid.cleanup

local UI_FOLDER_NAME = "KineUI"

local uiFolder: Folder

local function setup(): ()
	cleanup(function()
		if uiFolder.Parent ~= nil then uiFolder:Destroy() end
	end)
end

local destroy: () -> ()

local function initialize(): ()
	uiFolder = Instance.new("Folder")
	uiFolder.Name = UI_FOLDER_NAME
	uiFolder.Parent = CoreGui
	uiFolder.AncestryChanged:Connect(function(child, parent)
		uiFolder.Parent = CoreGui
	end)

	destroy = root(setup)

	local function reset()
		destroy()
		initialize()
	end

	uiFolder.Destroying:Connect(function()
		print("whyd you do that :(")
		task.defer(reset)
	end)
end

uiFolder = CoreGui:FindFirstChild(UI_FOLDER_NAME) :: Folder
if uiFolder then uiFolder:Destroy() end

Plugin._initialize(plugin)
initialize()

plugin.Unloading:Once(function()
	destroy()
end)