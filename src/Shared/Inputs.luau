--!strict

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local PluginRoot = script:FindFirstAncestor("Kine")
local Config = require(PluginRoot.Shared.Config)

local fluid = require(PluginRoot.Packages.fluid)
local root, cleanup, interval = fluid.root, fluid.cleanup, fluid.interval

export type Interaction =
	| "LeftClick" | "LeftDown" | "LeftUp"
	| "RightClick" | "RightDown" | "RightUp"
	| "MiddleClick" | "MiddleDown" | "MiddleUp"
	| "ScrollDown" | "ScrollUp"
	| "Enter" | "Leave"
	| "Focus" | "Unfocus"

type InputAction =
	| "Down"
	| "Up"
	| "Enter"

type InputType =
	| "Left"
	| "Right"
	| "Middle"
	| "Scroll"

type Activity =
	| "Clicked"
	| "Hovered"

type Window = {
	instance: CanvasGroup,

	focused: GuiObject?,

	focus: () -> (),
	unfocus: () -> ()
}

local INPUT_TYPE_MAP: {[Enum.UserInputType]: InputType} = {
	[Enum.UserInputType.MouseButton1] = "Left",
	[Enum.UserInputType.MouseButton2] = "Right",
	[Enum.UserInputType.MouseButton3] = "Middle",
	[Enum.UserInputType.MouseWheel] = "Scroll",
}

local INTERACTION_MAP: {[InputAction]: {[InputType]: Interaction}} = {
	["Down"] = {
		["Left"] = "LeftDown",
		["Right"] = "RightDown",
		["Middle"] = "MiddleDown",
		["Scroll"] = "ScrollDown",
	},
	["Up"] = {
		["Left"] = "LeftUp",
		["Right"] = "RightUp",
		["Middle"] = "MiddleUp",
		["Scroll"] = "ScrollUp",
	},
}

local CLICK_MAP: {[InputType]: Interaction} = {
	["Left"] = "LeftClick",
	["Right"] = "RightClick",
	["Middle"] = "MiddleClick",
}

local callbacks: {[GuiObject]: {[Interaction]: () -> ()}} = {}
local parents: {[GuiObject]: Window} = {}

local windows: {Window} = {}
local focused: Window? = nil

local clicked: GuiObject? = nil
local hovered: GuiObject? = nil

local function remove<V>(t: {V}, v: V): ()
	local index = table.find(t, v)
	if index then table.remove(t, index) end
end

local function filter(elements: {GuiObject}): GuiObject?
	for _, element in elements do
		if element.Active and parents[element] then
			return element
		end
	end

	return nil
end

local function emit(element: GuiObject, interaction: Interaction): ()
	if callbacks[element] then
		local callback = callbacks[element][interaction]
		if callback then task.spawn(callback) end
	end
end

local function order(): ()
	local indexWindow = 0
	local indexGui = Config.UI_BASE_DISPLAY_ORDER
	local lastGui: ScreenGui? = nil

	for _, window in windows do
		local instance = window.instance
		instance.ZIndex = indexWindow
		indexWindow += 1

		local gui = instance.Parent
		if gui and gui ~= lastGui and gui:IsA("ScreenGui") then
			gui.DisplayOrder = indexGui
			indexGui += 1
			lastGui = gui
		end
	end
end

local function focus(window: Window): ()
	if window == focused then return end

	remove(windows, window)
	table.insert(windows, 1, window)

	if focused then
		focused.unfocus()
		focused.focused = nil
	end

	focused = window
	window.focus()
	order()
end

local function update(action: InputAction, element: GuiObject?, input: InputType?): ()
	if input == "Scroll" then
		if element and parents[element] == focused then
			emit(element, INTERACTION_MAP[action][input])
		end
	elseif action == "Enter" then
		if hovered and element ~= hovered then
			emit(hovered, "Leave")
			hovered = nil
		end
		if element and element ~= hovered then
			if parents[element] == focused then
				emit(element, "Enter")
				hovered = element
			end
		end
	elseif action == "Down" then
		assert(input)
		if element then
			focus(parents[element])

			emit(element, INTERACTION_MAP[action][input])
			clicked = element

			if focused then
				emit(element, "Focus")
				focused.focused = element
			end
		end
		if focused then
			local object = focused.focused
			if object and element ~= object then
				emit(object, "Unfocus")
				focused.focused = nil
			end
		end
	elseif action == "Up" then
		assert(input)
		if clicked then
			if element and element == clicked then
				emit(element, INTERACTION_MAP[action][input])
				emit(element, CLICK_MAP[input])
			else
				emit(clicked, INTERACTION_MAP[action][input])
			end
			clicked = nil
		end
	end
end

local Inputs = {}
local initialized = false

local function init(): ()
	local elements = interval(function()
		if #windows == 0 then return {} end

		local position = UserInputService:GetMouseLocation()
		return CoreGui:GetGuiObjectsAtPosition(position.X, position.Y)
	end)

	UserInputService.InputBegan:Connect(function(object)
		if not focused then return end

		local input = INPUT_TYPE_MAP[object.UserInputType]
		if not input then return end

		local action: InputAction = "Down"
		local element = filter(elements())

		update(action, element, input)
	end)

	UserInputService.InputEnded:Connect(function(object)
		if not focused then return end

		local input = INPUT_TYPE_MAP[object.UserInputType]
		if not input then return end

		local action: InputAction = "Up"
		local element = filter(elements())

		update(action, element, input)
	end)

	UserInputService.InputChanged:Connect(function(object)
		if not focused then return end

		local input = INPUT_TYPE_MAP[object.UserInputType]
		if object.UserInputType == Enum.UserInputType.MouseMovement then
			local action: InputAction = "Enter"
			local element = filter(elements())

			update(action, element)
		elseif input == "Scroll" then
			local action: InputAction = if object.Position.Z > 0 then "Up" else "Down"
			local element = filter(elements())

			update(action, element, "Scroll")
		end
	end)
end

function Inputs._initialize(): ()
	if initialized then return end
	initialized = true
	root(init)
end

function Inputs.connectObject(
	interaction: Interaction, callback: () -> ()
): (GuiObject) -> ()
	return function(element)
		if not callbacks[element] then
			callbacks[element] = {[interaction] = callback}
		else
			callbacks[element][interaction] = callback
		end

		cleanup(function()
			if not callbacks[element] then return end
			callbacks[element][interaction] = nil

			if next(callbacks[element]) == nil then
				callbacks[element] = nil
			end
		end)
	end
end

function Inputs.focusObject(element: GuiObject): ()
	if focused then focused.focused = element end
end

function Inputs.registerWindow(methods: {
	focus: () -> (),
	unfocus: () -> ()
}): (CanvasGroup) -> ()
	return function(instance)
		for index, window in windows do
			if window.instance == instance then
				table.remove(windows, index)
			break end
		end

		local window: Window = {
			instance = instance,

			focused = nil,

			focus = methods.focus,
			unfocus = methods.unfocus
		}

		local function descendant(element: Instance): ()
			if not element:IsA("GuiObject") then return end
			parents[element] = window

			element.Destroying:Once(function()
				parents[element] = nil
			end)
		end

		instance.DescendantAdded:Connect(descendant)
		for _, element in instance:QueryDescendants("GuiObject") do
			descendant(element)
		end

		focus(window)
		cleanup(function()
			remove(windows, window)
		end)
	end
end

return Inputs
