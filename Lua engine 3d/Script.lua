-- Modules
local ReadFiles = require("Modules/Read")

-- code
local script = {}

function script.Config() -- that is the game configurations (size of the display and some things)
	local configs = {
		y = 10, -- recomended is 9 ~ 17
		x = 10, -- recomended is 9 ~ 17
		z = 10, -- recomended is 9 ~ 17
		gamename = "Lua engine 3d", -- game name
		background_hex = "8", -- background color in hex
		text_hex = "F", -- text color in hex
		}
	return configs
end

function script.load(plr, workspace, camera)
end

function script.tick(plr, workspace, camera)
	--if plr.params.li ~= "w" and plr.params.li ~= "a" and plr.params.li ~= "s" and plr.params.li ~= "d" and plr.params.li ~= "q" and plr.params.li ~= "e" then
	--	plr.params.lc = plr.params.li
	--end
end


return script