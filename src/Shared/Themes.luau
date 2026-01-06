--!strict

local PluginRoot = script:FindFirstAncestor("Kine")

local fluid = require(PluginRoot.Packages.fluid)
local source, root, derive = fluid.source, fluid.root, fluid.derive

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

local Themes = {
	themes = THEMES
} :: {
	current: Source<ThemeName>,
	colors: amalgamate<ThemeColors, Readable<Color3>>,
	themes: typeof(THEMES),

	_initialize: () -> ()
}

function Themes._initialize(): ()
	root(function()
		local current = source(THEME_DEFAULT)
		Themes.current = current
		Themes.colors = table.freeze {
			["Primary"] = derive(function() return THEMES[current()].Primary end),
			["Secondary"] = derive(function() return THEMES[current()].Secondary end),
			["Background"] = derive(function() return THEMES[current()].Background end),
			["Special"] = derive(function() return THEMES[current()].Special end),
			["Border"] = derive(function() return THEMES[current()].Border end),
			["Text"] = derive(function() return THEMES[current()].Text end),
		}
	end)
end

return Themes
