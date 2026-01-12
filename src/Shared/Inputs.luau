--!strict

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local PluginRoot = script:FindFirstAncestor("Kine")

local fluid = require(PluginRoot.Packages.fluid)
local root, cleanup, interval = fluid.root, fluid.cleanup, fluid.interval

export type Interaction =
	| "LeftClick" | "LeftDown" | "LeftUp"
	| "RightClick" | "RightDown" | "RightUp"
	| "MiddleClick" | "MiddleDown" | "MiddleUp"
	| "ScrollDown" | "ScrollUp"
	| "Enter" | "Leave"

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

	elements: {[GuiObject]: true},
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
local listeners: {[Interaction]: {[GuiObject]: true}} = {
	LeftClick = {}, LeftDown = {}, LeftUp = {},
	RightClick = {}, RightDown = {}, RightUp = {},
	MiddleClick = {}, MiddleDown = {}, MiddleUp = {},
	ScrollDown = {}, ScrollUp = {},
	Enter = {}, Leave = {},
}

local windows: {Window} = {}
local focused: Window? = nil

local clicked: GuiObject? = nil
local hovered: GuiObject? = nil

local function remove<V>(t: {V}, v: V): ()
	local index = table.find(t, v)
	if index then table.remove(t, index) end
end

local function filter(objects: {GuiObject}): GuiObject?
	local element: GuiObject?
	for _, object in objects do
		if object.Active then
			element = object
		break end
	end

	if element then
		for _, window in windows do
			if window.instance == element or window.elements[element] then
				return element
			end
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

local function unfocus(): ()
	if focused then
		focused.unfocus()
		focused.focused = nil
		focused = nil
	end
end

local function focus(window: Window): ()
	remove(windows, window)
	table.insert(windows, 1, window)

	unfocus()
	focused = window
	window.focus()
end

local function update(action: InputAction, element: GuiObject?, input: InputType?): ()
	if input == "Scroll" and element then
		emit(element, INTERACTION_MAP[action][input])
	elseif action == "Enter" then
		if hovered and element ~= hovered then
			emit(hovered, "Leave")
			hovered = nil
		end
		if element and element ~= hovered then
			emit(element, "Enter")
			hovered = element
		end
	elseif action == "Down" then
		assert(input)
		if element then
			local parent: Window?
			for _, window in windows do
				if window.instance == element or window.elements[element] then
					parent = window
				break end
			end

			assert(parent, "element clicked, but no parent window found")
			if parent ~= focused then
				focus(parent)
			end

			emit(element, INTERACTION_MAP[action][input])
			clicked = element
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
	local pass = interval(function()
		local position = UserInputService:GetMouseLocation()
		return CoreGui:GetGuiObjectsAtPosition(position.X, position.Y)
	end)

	local function wrap(
		callback: (object: InputObject, input: InputType, element: GuiObject?) -> ()
	): (InputObject, boolean) -> ()
		return function(object)
			local input = INPUT_TYPE_MAP[object.UserInputType]
			if not input then return end

			local element = filter(pass())
			callback(object, input, element)
		end
	end

	UserInputService.InputBegan:Connect(wrap(function(object, input, element)
		local action: InputAction = "Down"
		if input == "Scroll" then
			action = if object.Position.Y > 0 then "Up" else "Down"
		end
		update(action, element, input)
	end))

	UserInputService.InputEnded:Connect(wrap(function(object, input, element)
		local action: InputAction = "Up"
		update(action, element, input)
	end))

	UserInputService.InputChanged:Connect(function(object)
		if object.UserInputType == Enum.UserInputType.MouseMovement then
			local element = filter(pass())
			update("Enter", element)
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
	-- weird syntax so that fluid.action can be used effectively
	return function(element)
		listeners[interaction][element] = true
		if not callbacks[element] then
			callbacks[element] = {[interaction] = callback}
		else
			callbacks[element][interaction] = callback
		end

		cleanup(function()
			listeners[interaction][element] = nil
			if not callbacks[element] then return end

			callbacks[element][interaction] = nil
			if next(callbacks[element]) == nil then
				callbacks[element] = nil
			end
		end)
	end
end

function Inputs.registerWindow(methods: {
	focus: () -> (),
	unfocus: () -> ()
}): (CanvasGroup) -> ()
	-- weird syntax so that fluid.action can be used effectively
	return function(instance)
		for index, window in windows do
			if window.instance == instance then
				table.remove(windows, index)
			break end
		end

		local window: Window = {
			instance = instance,

			elements = {},
			focused = nil,

			focus = methods.focus,
			unfocus = methods.unfocus
		}

		local function descendant(element: Instance): ()
			if not element:IsA("GuiObject") then return end
			window.elements[element] = true

			element.Destroying:Once(function()
				window.elements[element] = nil
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
