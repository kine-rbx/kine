--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Design = require(PluginRoot.Shared.Design)
local Plugin = require(PluginRoot.Shared.Plugin)
local Signal = require(PluginRoot.Common.Signal)

local fluid = require(PluginRoot.Packages.fluid)
local root, source, effect, create, cleanup, mount = fluid.root, fluid.source, fluid.effect, fluid.create, fluid.cleanup, fluid.mount

local Window = require(PluginRoot.Components.Window)
local TitleBar = require(PluginRoot.Components.TitleBar)
local MenuBar = require(PluginRoot.Components.MenuBar)

local pluginButton = Plugin.buttons["Editor"]

local activeGui: ScreenGui? = nil

local destroy: () -> ()? = nil
local window = {
	open = source(true),
	minimized = source(false),

	position = source(vector.create(math.huge, 0)),
	size = source(Design.WINDOWS["EDITOR"].SIZE_DEFAULT),

	requestClose = Signal.new(),
	requestMinimize = Signal.new()
}

type Signal<T...> = Signal.Signal<T...>

local function die(): ()
	if destroy then task.spawn(destroy) end
	destroy = nil
end

local function setup(): ()
	assert(activeGui)

	window.open(true)
	window.minimized(false)

	if window.position().x == math.huge then
		window.position(vector.create(activeGui.AbsoluteSize.X, activeGui.AbsoluteSize.Y) // 2)
	end

	window.requestClose:connect(die)
	window.requestMinimize:connect(function()
		window.minimized(not window.minimized())
	end)

	effect(function()
		if window.minimized() then
			pluginButton.reset()
		end
	end)

	local function ui(): {Instance}
		local frame = Window {
			Open = window.open,

			Position = window.position,
			Size = window.size,
		}

		mount(function()
			local titleBar = TitleBar {
				RequestClose = window.requestClose,
				RequestMinimize = window.requestMinimize
			}
			local menuBar = MenuBar {
				{
					Text = "File",
					Dropdown = {}
				}
			}
			local container = nil

			return {
				titleBar,
				menuBar,
				container,

				create("UIListLayout") {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,

					VerticalAlignment = Enum.VerticalAlignment.Top,
				}
			}
		end, frame)

		effect(function()
			frame.Visible = not window.minimized()
		end)

		return {frame}
	end

	mount(ui, activeGui)

	cleanup(function()
		pluginButton.reset()
		window.open(false)
		window.minimized(false)

		task.wait(Design.WINDOW.TRANSITION.TIME)
		if activeGui and activeGui.Parent then activeGui:Destroy() end
	end)
end

return function(uiFolder: Folder): ()
	if activeGui then
		activeGui:Destroy()
		activeGui = nil
	end

	local connection = pluginButton.onClick:connect(function()
		if activeGui and activeGui.Parent then
			if window.minimized() then
				window.minimized(false)
			else
				die()
			end
		else
			activeGui = create("ScreenGui") {
				Name = "Editor",
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

				Parent = uiFolder
			}
			die()
			destroy = root(setup)
		end
	end)

	cleanup(function()
		connection:disconnect()
	end)
end
