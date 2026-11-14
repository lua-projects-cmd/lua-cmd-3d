-- read files with this structure:
-- name=value
local m = {}
function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
function m:read(file) -- string
	local b = {}
	for line in io.lines(file) do
		local abc = split(line,"=")
		local name, value = abc[1], abc[2]
		b[name] = value
	end
	return b
end
return m