--!strict

export type Dropdown = {}

return function(): () -> ()
	-- receive Dropdown type and return function which instantiates the dropdown
	-- only one dropdown can exist at a time, should be global (maybe per plugin scope but that'll be difficult)
	-- also automatically removes active dropdown if made inactive by clicking on other stuff etc
	return function()
		print("activated dropdown")
	end
end
