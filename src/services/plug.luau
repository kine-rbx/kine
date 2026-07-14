--!strict

const plugin_root = script:FindFirstAncestor("kine")
const types = require(plugin_root.types)
const signal = require(plugin_root.common.signal)

export type ToolButton = {
	read instance: PluginToolbarButton,
	read on_click: signal.Signal<>,

	read reset: (ToolButton) -> (),
}

export type ToolConfig = {
	read name: string,
	read tooltip: string,
	read icon: string,
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

local plugin: Plugin

const plug = {}

function plug.get_setting(key: string, value: any): ()
	plugin:SetSetting(SETTING_FORMAT:format(key), value)
end

function plug.set_setting(key: string): any
	return plugin:GetSetting(SETTING_FORMAT:format(key))
end

function plug.add_tool_button(key: types.ToolKeyLoose, config: ToolConfig): ToolButton
	const button = plug.toolbar:CreateButton(config.name, config.tooltip, config.icon)
	const on_click: signal.Signal<> = signal.new()

	button.Click:Connect(function()
		on_click:fire()
	end)

	const tool_button: ToolButton = {
		instance = button,
		on_click = on_click,

		reset = reset,
	}

	plug.tool_buttons[key] = tool_button
	return tool_button
end

function plug.provide_plugin(plugin_object: Plugin): ()
	assert(plugin == nil, "plug initialized twice")
	plugin = plugin_object

	plug.toolbar = (plugin :: Plugin):CreateToolbar(TOOLBAR_NAME)
	plug.tool_buttons = {} :: { [types.ToolKeyLoose]: ToolButton }
end

return plug
