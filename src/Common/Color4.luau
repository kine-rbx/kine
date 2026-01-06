--!strict
--!native

local FORMAT_HEX_RGBA = "%02x%02x%02x%02x" :: "%02x%02x%02x%02x"
local FORMAT_HEX_RGB = "%02x%02x%02x" :: "%02x%02x%02x"

local function clamp8(v: number): number
	return math.clamp(v, 0, 255)
end

export type Color4 = {
	read R: number,
	read G: number,
	read B: number,
	read A: number
}

local Color4 = {}

function Color4.toColor3(color: Color4): (Color3, number)
	return Color3.new(color.R, color.G, color.B), color.A
end

function Color4.toRGBA(color: Color4): (number, number, number, number)
	return
		math.round(color.R * 255),
		math.round(color.G * 255),
		math.round(color.B * 255),
		math.round(color.A * 255)
end

function Color4.toHSVA(color: Color4): (number, number, number, number)
	local r = color.R
	local g = color.G
	local b = color.B

	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local delta = max - min

	local h = 0
	local s = max == 0 and 0 or delta / max
	local v = max

	if delta > 0 then
		if max == r then
			h = (g - b) / delta
		elseif max == g then
			h = (b - r) / delta + 2
		else
			h = (r - g) / delta + 4
		end

		h = (h / 6) % 1
	end

	return h, s, v, color.A
end

function Color4.toHex(color: Color4, strip: boolean?): string
	local r, g, b, a = Color4.toRGBA(color)
	return strip
		and FORMAT_HEX_RGB:format(clamp8(r), clamp8(g), clamp8(b))
		or FORMAT_HEX_RGBA:format(clamp8(r), clamp8(g), clamp8(b), clamp8(a))
end

function Color4.fromColor3(color: Color3, alpha: number?): Color4
	return table.freeze {R = color.R, G = color.G, B = color.B, A = alpha or 1}
end

function Color4.fromRGBA(red: number, green: number, blue: number, alpha: number?): Color4
	return table.freeze {R = red / 255, G = green / 255, B = blue / 255, A = (alpha or 255) / 255}
end

function Color4.fromHSVA(hue: number, saturation: number, value: number, alpha: number?): Color4
	local c = value * saturation
	local h = hue * 6
	local x = c * (1 - math.abs(h % 2 - 1))
	local m = value - c

	local r: number
	local g: number
	local b: number

	local i = (h // 1) % 6
	if i == 0 then
		r, g, b = c, x, 0
	elseif i == 1 then
		r, g, b = x, c, 0
	elseif i == 2 then
		r, g, b = 0, c, x
	elseif i == 3 then
		r, g, b = 0, x, c
	elseif i == 4 then
		r, g, b = x, 0, c
	else
		r, g, b = c, 0, x
	end

	return table.freeze {R = r + m, G = g + m, B = b + m, A = alpha or 1}
end

function Color4.fromHex(hex: string): Color4
	hex = hex:gsub("#", ""):lower()

	if #hex == 3 or #hex == 4 then
		hex = hex:gsub("(.)", "%1%1")
	elseif #hex ~= 6 and #hex ~= 8 then
		error("invalid hex string length")
	end

	local value = assert(tonumber(hex, 16), "invalid hex string")

	local r = (value // 2^24)
	local g = (value // 2^16) % 2^8
	local b = (value // 2^8) % 2^8
	local a = #hex == 8 and value % 2^8 or 255

	return table.freeze {R = r / 255, G = g / 255, B = b / 255, A = a / 255}
end

function Color4.new(red: number, green: number, blue: number, alpha: number?): Color4
	return table.freeze {R = red, G = green, B = blue, A = alpha or 1}
end

return Color4
