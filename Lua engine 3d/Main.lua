--game logic

-- modules
local engine = require("Modules/engine")
local script = require("Script")

-- code
local config = script.Config()
local xmax, ymax, zmax = config.x, config.y, config.z
os.execute("title "..config.gamename)
os.execute("color "..config.background_hex..config.text_hex)
--

local workspace = engine.workspace(xmax,ymax,zmax)
local camera  = engine.camera(1,1,1,"front")
local player = engine.character(2,2,2,100,{lc = "", li = ""})

local debugmode = false

player.params.lc = workspace[player.x][player.y][player.z]
workspace[player.x][player.y][player.z] = "☻"

script.load(player,workspace,camera)

function info()
	print("health: "..player.health)
	if debugmode then
		print("camera is in: ".. camera.facing)
		print("pos: x: "..player.x.."; y: "..player.y.."; z: "..player.z)
		print("cpos: x: "..camera.x.."; y: "..camera.y.."; z: "..camera.z)
		print("last_cell: "..player.params.lc)
		print("last_input: "..player.params.li)
		print("using memory in KBytes: "..collectgarbage("count"))
	end
end
function updateCameraPos()
	camera.z = player.z
	camera.y = player.y
	camera.x = player.x
end

while true do
	collectgarbage("collect")
	if player.health > 0 then
		updateCameraPos()
		engine.draw()
		info()
		script.tick(player,workspace,camera)
		local input = engine.input()
		input = string.lower(input)
		player.params.li = input
		-- 6 ... 0 ... - = camera movement
		-- wasd = player moovement
		-- future : 1..5 = inventory, 1 = nil
		while input == "6" or input == "7" or input == "8" or input == "9" or input == "0" or input == "-" or input == "debug" do
			if input == "6" then
				camera.facing = "front"
			elseif input == "7" then
				camera.facing = "back"
			elseif input == "8" then
				camera.facing = "right"
			elseif input == "9" then
				camera.facing = "left"
			elseif input == "0" then
				camera.facing = "up"
			elseif input == "-" then
				camera.facing = "down"
			elseif input == "debug" then
				debugmode = not debugmode
			end
			engine.draw()
			info()
			input = engine.input()
			input = string.lower(input)
			player.params.li = input
		end
		-- removed because of conflict with script.tick()
		--while input ~= "w" and input ~= "s" and input ~= "a" and input ~= "d" and input ~= "exit" and input ~= "q" and input ~= "e" do
		--	engine.draw()
		--	print("sorry, your input isn't valid, please type again")
		--	input = engine.input()
		--	input = string.lower(input)
		--	player.params.li = input
		--end

		if input == "exit" then
			player.health = 0

		elseif input == "w" then
			if workspace[player.x][player.y][player.z + 1] ~= nil and engine.cells.Cells[engine.getNameCell(workspace[player.x][player.y][player.z + 1])].Collide == false then
				workspace[player.x][player.y][player.z] = player.params.lc
				player.params.lc = workspace[player.x][player.y][player.z + 1]
				workspace[player.x][player.y][player.z + 1] = "☻"
				player.z = player.z + 1
			end
		elseif input == "s" then
			if workspace[player.x][player.y][player.z -1] ~= nil and engine.cells.Cells[engine.getNameCell(workspace[player.x][player.y][player.z - 1])].Collide == false then
				workspace[player.x][player.y][player.z] = player.params.lc
				player.params.lc = workspace[player.x][player.y][player.z -1]
				workspace[player.x][player.y][player.z -1] = "☻"
				player.z = player.z -1
			end
		elseif input == "d" then
			if workspace[player.x][player.y + 1]~= nil and engine.cells.Cells[engine.getNameCell(workspace[player.x][player.y + 1][player.z])].Collide == false then
				workspace[player.x][player.y][player.z] = player.params.lc
				player.params.lc = workspace[player.x][player.y+1][player.z]
				workspace[player.x][player.y+1][player.z] = "☻"
				player.y = player.y +1
			end
		elseif input == "a" then
			if workspace[player.x][player.y -1]~= nil and engine.cells.Cells[engine.getNameCell(workspace[player.x][player.y - 1][player.z])].Collide == false then
				workspace[player.x][player.y][player.z] = player.params.lc
				player.params.lc = workspace[player.x][player.y-1][player.z]
				workspace[player.x][player.y-1][player.z] = "☻"
				player.y = player.y -1
			end
		elseif input == "q" then
			if workspace[player.x -1] ~= nil and engine.cells.Cells[engine.getNameCell(workspace[player.x - 1][player.y][player.z])].Collide == false then
				workspace[player.x][player.y][player.z] = player.params.lc
				player.params.lc = workspace[player.x-1][player.y][player.z]
				workspace[player.x-1][player.y][player.z] = "☻"
				player.x = player.x -1
			end
		elseif input == "e" then
			if workspace[player.x +1] ~= nil and engine.cells.Cells[engine.getNameCell(workspace[player.x + 1][player.y][player.z])].Collide == false then
				workspace[player.x][player.y][player.z] = player.params.lc
				player.params.lc = workspace[player.x+1][player.y][player.z]
				workspace[player.x+1][player.y][player.z] = "☻"
				player.x = player.x +1
			end
		end
		-- check damage
		local cellname = engine.getNameCell(player.params.lc)
		if engine.cells.Cells[cellname] then
			player.health = player.health - engine.cells.Cells[cellname].damage
		end
		
	else
		print("exit")
		break
	end
end

