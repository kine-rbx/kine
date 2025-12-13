--!strict
--!optimize 2

local PluginRoot = script:FindFirstAncestor("Kine")
local Signal = require(PluginRoot.Utility.Signal)

type Signal<T...> = Signal.Signal<T...>

type PluginButtonConfig = {
	read tooltip: string,
	read icon: string
}

export type PluginKey =
	| "Editor"

export type PluginButton = {
	read _instance: PluginToolbarButton,

	read onClick: Signal<>,
	read reset: () -> ()
}

local BUTTON_CONFIG: {[PluginKey]: PluginButtonConfig} = {
	["Editor"] = {
		tooltip = "Create and edit animations",
		icon = ""
	}
}

local TOOLBAR_NAME = "Kine"
local SETTING_FORMAT = "KineConfig-%s" :: "KineConfig-%s"

local function reset(button: PluginToolbarButton): ()
	button.Enabled = false
	button.Enabled = true
end

local Plugin = {}
local plugin: Plugin

Plugin.buttons = {} :: {[PluginKey | string]: PluginButton}

function Plugin._initialize(_plugin: Plugin): ()
	if plugin then return end
	plugin = _plugin

	local toolbar = _plugin:CreateToolbar(TOOLBAR_NAME)

	for key, config in BUTTON_CONFIG do
		local button = toolbar:CreateButton(key, config.tooltip, config.icon)
		local onClick = Signal.new() :: Signal<>

		button.Click:Connect(function()
			onClick:fire()
		end)

		Plugin.buttons[key] = {
			_instance = button,

			onClick = onClick,
			reset = function()
				task.defer(reset, button)
			end
		}
	end
end

function Plugin.setSetting(key: string, value: any): ()
	plugin:SetSetting(SETTING_FORMAT:format(key), value)
end

function Plugin.getSetting(key: string): any
	return plugin:GetSetting(SETTING_FORMAT:format(key))
end

return Plugin
