--!strict

local PluginRoot = script:FindFirstAncestor("Kine")
local Plugin = require(PluginRoot.Shared.Plugin)
local Signal = require(PluginRoot.Common.Signal)

local fluid = require(PluginRoot.Packages.fluid)

local Window = require(PluginRoot.Components.Window)
local TitleBar = require(PluginRoot.Components.TitleBar)
local MenuBar = require(PluginRoot.Components.MenuBar)

local TokensWindow = require(PluginRoot.Tokens.Window)
local TokensEditorWindow = require(PluginRoot.Tokens.Window.EditorWindow)

type Source<T> = fluid.Source<T>
type Signal<T...> = Signal.Signal<T...>

type WindowContext = {
	open: Source<boolean>,
	minimized: Source<boolean>,

	position: Source<vector>,
	size: Source<vector>,

	onClose: Signal<>,
	onMinimize: Signal<>,
}

local pluginButton = Plugin.buttons["Editor"]

local activeGui: ScreenGui? = nil

return function(uiFolder: Folder): ()
	local destroy: () -> ()? = nil
	local window: WindowContext

	if activeGui then
		activeGui:Destroy()
		activeGui = nil
	end

	local function reset(): ()
		local position = window and window.position()
		local size = window and window.size()

		window = {
			open = fluid.source(true),
			minimized = fluid.source(false),

			position = fluid.source(position or vector.create(math.huge, 0)),
			size = fluid.source(size or TokensEditorWindow.SIZE_DEFAULT),

			onClose = Signal.new(),
			onMinimize = Signal.new(),
		}
	end

	local function die(): ()
		if destroy then task.spawn(destroy) end
		destroy = nil
	end

	local function setup(): ()
		assert(activeGui)
		reset()

		if window.position().x == math.huge then
			window.position(vector.create(activeGui.AbsoluteSize.X, activeGui.AbsoluteSize.Y) // 2)
		end

		window.onClose:connect(die)
		window.onMinimize:connect(function()
			window.minimized(not window.minimized())
		end)

		fluid.effect(function()
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

			fluid.mount(function()
				local titleBar = TitleBar {
					Title = TokensEditorWindow.TITLE,

					OnClose = window.onClose,
					OnMinimize = window.onMinimize,
				}

				local menuBar = MenuBar {
					Items = {
						{
							Text = "File",
							Dropdown = {}
						},
						{
							Text = "Edit",
							Dropdown = {}
						},
						{
							Text = "Object",
							Dropdown = {}
						},
					},
				}

				local container = nil

				return {
					titleBar,
					menuBar,
					container,

					fluid.create("UIListLayout") {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,

						VerticalAlignment = Enum.VerticalAlignment.Top,
					},
				}
			end, frame)

			fluid.effect(function()
				frame.Visible = not window.minimized()
			end)

			return {frame}
		end

		fluid.mount(ui, activeGui)

		fluid.cleanup(function()
			pluginButton.reset()
			window.open(false)
			window.minimized(false)

			task.wait(TokensWindow.TRANSITION.TIME)
			if activeGui and activeGui.Parent then activeGui:Destroy() end
		end)
	end

	local connection = pluginButton.onClick:connect(function()
		if activeGui and activeGui.Parent then
			if window.minimized() then
				window.minimized(false)
			else
				die()
			end
		else
			activeGui = fluid.create("ScreenGui") {
				Name = "Editor",
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

				Parent = uiFolder,
			}
			die()
			destroy = fluid.root(setup)
		end
	end)

	fluid.cleanup(function()
		connection:disconnect()
	end)
end
