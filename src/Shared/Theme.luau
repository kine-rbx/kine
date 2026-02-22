--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local fluid = require(PluginRoot.Packages.fluid)
local source, derive = fluid.source, fluid.derive

type Source<T> = fluid.Source<T>
type Readable<T> = () -> T

export type ThemeColor =
	| "Primary"
	| "Secondary"
	| "Background"
	| "Special"
	| "Border"
	| "Text"

export type ThemeName =
	| "Umbra"

local THEME_DEFAULT: ThemeName = "Umbra"
local THEMES: {[ThemeName]: {[ThemeColor]: Color3}} = {
	["Umbra"] = {
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
	colors: {[ThemeColor]: Readable<Color3>},
	themes: typeof(THEMES),

	_init: () -> ()
}

function Theme._init(): ()
	Theme._init = function() end

	local active = source(THEME_DEFAULT)
	Theme.active = active
	Theme.colors = {
		["Primary"] = derive(function() return THEMES[active()].Primary end),
		["Secondary"] = derive(function() return THEMES[active()].Secondary end),
		["Background"] = derive(function() return THEMES[active()].Background end),
		["Special"] = derive(function() return THEMES[active()].Special end),
		["Border"] = derive(function() return THEMES[active()].Border end),
		["Text"] = derive(function() return THEMES[active()].Text end),
	}

	table.freeze(Theme.colors)
	table.freeze(Theme)
end

return Theme
