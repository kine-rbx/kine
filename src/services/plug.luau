--!strict

const plugin_root = script:FindFirstAncestor("kine")
const types = require(plugin_root.types)

export type ToolButton = {
	instance: PluginToolbarButton,
	reset: (ToolButton) -> (),
}

export type ToolConfig = {
	name: string,
	tooltip: string,
	icon: string,

	on_click: () -> (),
}

const TOOLBAR_NAME = "Kine"
const SETTING_FORMAT = "KINE--%s"

const function reset_button(button: PluginToolbarButton): ()
	button.Enabled = false
	button.Enabled = true
end

const function reset(self: ToolButton): ()
	task.defer(reset_button, self.instance)
end

const plug = {}
local initialized = false

local plugin: Plugin

function plug.get_setting(key: string, value: any): ()
	plugin:SetSetting(SETTING_FORMAT:format(key), value)
end

function plug.set_setting(key: string): any
	return plugin:GetSetting(SETTING_FORMAT:format(key))
end

function plug.add_tool_button(key: types.ToolKey | string, config: ToolConfig): ToolButton
	const button = plug.toolbar:CreateButton(config.name, config.tooltip, config.icon)
	button.Click:Connect(config.on_click)

	const tool_button: ToolButton = {
		instance = button,
		reset = reset,
	}

	plug.tool_buttons[key] = tool_button
	return tool_button
end

function plug._init(_plugin: Plugin): ()
	assert(not initialized, "plug initialized twice")
	initialized = true

	plugin = _plugin
	plug.toolbar = plugin:CreateToolbar(TOOLBAR_NAME)
	plug.tool_buttons = {} :: { [types.ToolKey | string]: ToolButton }
end

return plug
