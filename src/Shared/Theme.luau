--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local fluid = require(PluginRoot.Packages.fluid)

type Source<T> = fluid.Source<T>
type Readable<T> = () -> T

export type ThemeColor =
	| "Primary"
	| "Secondary"
	| "Background"
	| "Special"
	| "Border"
	| "Text"

export type ThemeMode =
	| "Light"
	| "Dark"

export type ThemeName =
	| "Umbra"

local THEME_DEFAULT: ThemeName = "Umbra"
local THEMES: {[ThemeName]: {Mode: ThemeMode, [ThemeColor]: Color3}} = {
	["Umbra"] = {
		Mode = "Dark",
		Primary = Color3.fromHex("#9c7663"),
		Secondary = Color3.fromHex("#826252"),
		Background = Color3.fromHex("#2a272d"),
		Special = Color3.fromHex("#ffc492"),
		Border = Color3.fromHex("#bc937e"),
		Text = Color3.fromHex("#ffffff"),
	},
}
table.freeze(THEMES)

local Theme = {
	themes = THEMES
} :: {
	active: Source<ThemeName>,
	mode: Readable<ThemeMode>,
	colors: {[ThemeColor]: Readable<Color3>},
	themes: typeof(THEMES),

	_init: () -> ()
}

function Theme._init(): ()
	Theme._init = function() end

	local active = fluid.source(THEME_DEFAULT)
	Theme.active = active
	Theme.mode = fluid.derive(function() return THEMES[active()].Mode end)
	Theme.colors = {
		["Primary"] = fluid.derive(function() return THEMES[active()].Primary end),
		["Secondary"] = fluid.derive(function() return THEMES[active()].Secondary end),
		["Background"] = fluid.derive(function() return THEMES[active()].Background end),
		["Special"] = fluid.derive(function() return THEMES[active()].Special end),
		["Border"] = fluid.derive(function() return THEMES[active()].Border end),
		["Text"] = fluid.derive(function() return THEMES[active()].Text end),
	}

	table.freeze(Theme.colors)
	table.freeze(Theme)
end

return Theme
