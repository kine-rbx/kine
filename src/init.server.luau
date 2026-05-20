--!strict

local CoreGui = game:GetService("CoreGui")

local plugin_root = script
local global = require(plugin_root.global)
local fluid = require(plugin_root.fluid)

local CONFIG = global.CONFIG

local unload: () -> ()

local function init(): ()
	local ui_folder = CoreGui:FindFirstChild(CONFIG.UI_FOLDER_NAME) :: Folder
	if ui_folder then ui_folder:Destroy() end

	ui_folder = Instance.new("Folder")
	ui_folder.Name = CONFIG.UI_FOLDER_NAME
	ui_folder.Parent = CoreGui
	global.ui_folder = ui_folder

	local reparent_connection = ui_folder.AncestryChanged:Connect(function()
		ui_folder.Parent = CoreGui
	end)

	fluid.cleanup(function()
		reparent_connection:Disconnect()
		global.ui_folder = nil
		if ui_folder.Parent ~= nil then ui_folder:Destroy() end
	end)
end

local function load(): ()
	require(plugin_root.service.plug)._init(plugin)
	init()

	for _, module in plugin_root.tools:GetChildren() do
		local tool = require(module) :: () -> ()
		if tool and typeof(tool) == "function" then tool() end
	end
end

plugin.Unloading:Once(function()
	if unload then unload() end
end)

unload = fluid.root(load)
