--!strict

export type WindowContext = {}

local window_context = {}

function window_context.new(): WindowContext
	return {}
end

return window_context
