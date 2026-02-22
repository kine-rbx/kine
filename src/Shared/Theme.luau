--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local fluid = require(PluginRoot.Packages.fluid)
local source, derive = fluid.source, fluid.derive

type Source<T> = fluid.Source<T>
type Readable<T> = () -> T

type function amalgamate(key: type, value: type)
	local tb = types.newtable()

	if key:is("table") then
		for k, p in key:properties() do
			if p.read then tb:setreadproperty(k, value) end
			if p.write then tb:setwriteproperty(k, value) end
		end
	end

	return tb
end

export type ThemeName =
	| "Umbra"

type ThemeColors = {
	read Primary: Color3,
	read Secondary: Color3,
	read Background: Color3,
	read Special: Color3,
	read Border: Color3,
	read Text: Color3,
}

local THEME_DEFAULT: ThemeName = "Umbra"
local THEMES: {[ThemeName]: ThemeColors} = {
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
	colors: amalgamate<ThemeColors, Readable<Color3>>,
	themes: typeof(THEMES),

	_init: () -> ()
}

function Theme._init(): ()
	Theme._init = function() end

	local active = source(THEME_DEFAULT)
	Theme.active = active
	Theme.colors = table.freeze {
		["Primary"] = derive(function() return THEMES[active()].Primary end),
		["Secondary"] = derive(function() return THEMES[active()].Secondary end),
		["Background"] = derive(function() return THEMES[active()].Background end),
		["Special"] = derive(function() return THEMES[active()].Special end),
		["Border"] = derive(function() return THEMES[active()].Border end),
		["Text"] = derive(function() return THEMES[active()].Text end),
	}

	table.freeze(Theme)
end

return Theme
