-- Trys to replicate 3d
local graphics = {
	cells = {
		Cells = {
			["Air"] = {i = "░", Collide = false, damage = (0),dshade = "░",},
			["Wall"] = {i = "█", Collide = true, damage = (0),dshade = "▓",},
			["Player"] = {i = "☻", Collide = false, damage = (0),dshade = "☺",},
		};
		Symbol = {
			["░"] = "Air";
			["█"] = "Wall";
			["☻"] = "Player";
			Dshade = {
				["░"] = "Air";
				["▓"] = "Wall";
				["☺"] = "Player";
			};
		};
	};
	models = {
	};
}

local currentWorkspace = nil
local currentCamera = nil

function graphics.workspace(x,y,z) -- height, width, lenght
	local newWorkspace = table.create(x)
	local AirCell = graphics.cells.Cells["Air"].i
	for i1 =  1, x do
		newWorkspace[i1] = table.create(y)
		for i2 = 1, y do
			newWorkspace[i1][i2] = table.create(z)
			for i3 = 1, z do
				newWorkspace[i1][i2][i3] = AirCell
			end
		end
	end
	currentWorkspace = newWorkspace
	return newWorkspace
end
function graphics.camera(x,y,z,facing) -- height, width, lenght, facing up, down, left, right, front, back -- think it's simple to NOT use the x,y,z
	local newCamera = {}
	newCamera.x = x
	newCamera.y = y
	newCamera.z = z
	newCamera.facing = facing
	currentCamera = newCamera
	return newCamera
end

function graphics.getNameCell(cell)
	local name = graphics.cells.Symbol[cell]
	if name then
		return name
	else
		name = graphics.cells.Symbol.Dshade[cell]
		if name then
			return name
		end
		return "Air"
	end
end
function graphics.getNameDshade(cell)
	local name = graphics.cells.Symbol[cell]
	if name then
		return name
	else
	end
end
function graphics.createCell(symbol,name,collision,damage,dshade)
	local properties = {i = symbol, Collide = collision, damage = (damage),dshade = dshade,}
	graphics.cells.Cells[name] = properties
	graphics.cells.Symbol[symbol] = name
end
function graphics.ChangeWorkspace(source)
	currentWorkspace = source
end

function graphics.draw()
	local ax = #currentWorkspace
	local ay = #currentWorkspace[1]
	local az = #currentWorkspace[1][1]
	local system = os.getenv("OS")
	os.execute(system == "Windows_NT" and "cls" or "clear")
	assert(type(currentWorkspace) == "table", "graphics error: current workspace doesn't exist :(" ) 
	assert(type(currentCamera) == "table", "graphics error: current camera doesn't exist :(")
	local string = "" -- the line (ex: █ ░ █ ░)
	if currentCamera.facing == "front" then
		for aq1, x in pairs(currentWorkspace) do
			if aq1 >= currentCamera.x -2 and aq1 <= currentCamera.x + 2 then
				if type(x) == "table" then
					for aq2, y in pairs(x) do
						if aq2 >= currentCamera.y -2 and aq2 <= currentCamera.y + 2 then
							if type(y) == "table" then
								local cell = ""
								for num, z in pairs(y) do
									if type(z) == "string" and z ~= graphics.cells.Cells["Air"].i then
										cell = z
										-- distance shade
										if num == #y then
											local name = graphics.getNameDshade(z)
											if graphics.cells.Cells[name] then
												cell = graphics.cells.Cells[name].dshade
											end		
										end
								
										break
									elseif type(z) == "string" then
										cell = graphics.cells.Cells["Air"].i
									end
								end
								string = string.." "..cell
							end
						end
					end
					print(string)
					string = ""
				end
			end
		end
	elseif currentCamera.facing == "back" then
		for aq1, x in pairs(currentWorkspace) do
			if aq1 >= currentCamera.x -2 and aq1 <= currentCamera.x + 2 then
				if type(x) == "table" then
					for ind2 = #x,1,-1 do
						local y = x[ind2]
						if ind2 >= currentCamera.y -2 and ind2 <= currentCamera.y + 2 then
							if type(y) == "table" then
								local cell = ""
								for ind3 = #y,1,-1 do
									local z = y[ind3]
									if type(z) == "string" and z ~= graphics.cells.Cells["Air"].i then
										cell = z
										if ind3 == 1 then
											local name = graphics.getNameDshade(z)
											if graphics.cells.Cells[name] then
												cell = graphics.cells.Cells[name].dshade
											end
										end
										break
									elseif type(z) == "string" then
										cell = graphics.cells.Cells["Air"].i
									end
								end
								string = string.." "..cell
							end
						end
					end
					print(string)
					string = ""
				end
			end
		end
	elseif currentCamera.facing == "up" then
		-- eu tentei de todas formas posssiveis deixa o esquema unifrome, por enquanto vou fazer gambiarras
		for z = az,1,-1 do
			if z >= currentCamera.z -2 and z <= currentCamera.z + 2 then
				for y = 1,ay do
					if y >= currentCamera.y -2 and y <= currentCamera.y + 2 then
						local cell = ""
						for x = 1,ax do
							local abz = currentWorkspace[x][y][z]
							if type(abz) == "string" and abz ~= graphics.cells.Cells["Air"].i then
								cell = abz
								-- distance shade
								if x == ax then
									local name = graphics.getNameDshade(abz)
									if graphics.cells.Cells[name] then
										cell = graphics.cells.Cells[name].dshade
									end
								end
								break
							elseif type(abz) == "string" then
								cell = graphics.cells.Cells["Air"].i
							end
						end
						string = string.." "..cell
					end
				end
			end
			print(string)
			string = ""
		end
	elseif currentCamera.facing == "down" then
		for z = 1,az do
			if z >= currentCamera.z -2 and z <= currentCamera.z + 2 then
				for y = 1,ay do
					if y >= currentCamera.y -2 and y <= currentCamera.y + 2 then
						local cell = ""
						for x = ax,1,-1 do
							local abz = currentWorkspace[x][y][z]
							if type(abz) == "string" and abz ~= graphics.cells.Cells["Air"].i then
								cell = abz
								-- distance shade
								if x == 1 then
									local name = graphics.getNameDshade(abz)
									if graphics.cells.Cells[name] then
										cell = graphics.cells.Cells[name].dshade
									end
								end
								break
							elseif type(abz) == "string" then
								cell = graphics.cells.Cells["Air"].i
							end
						end
						string = string.." "..cell
					end
				end
			end
			print(string)
			string = ""
		end
	elseif currentCamera.facing == "right" then
		for x = 1,ax do
			if x >= currentCamera.x -2 and x <= currentCamera.x + 2 then
				for z = 1,az do
					if z >= currentCamera.z -2 and z <= currentCamera.z + 2 then
						local cell = ""
						for y = ay,1,-1 do
							local abz = currentWorkspace[x][y][z]
							if type(abz) == "string" and abz ~= graphics.cells.Cells["Air"].i then
								cell = abz
								-- distance shade
								if y == 1 then
									local name = graphics.getNameDshade(abz)
									if graphics.cells.Cells[name] then
										cell = graphics.cells.Cells[name].dshade
									end
								end
								break
							elseif type(abz) == "string" then
								cell = graphics.cells.Cells["Air"].i
							end
						end
						string = string.." "..cell
					end
				end
				print(string)
				string = ""
			end
		end
	elseif currentCamera.facing == "left" then
		for x = 1,ax do
			if x >= currentCamera.x -2 and x <= currentCamera.x + 2 then
				for z = az,1,-1 do
					if z >= currentCamera.z -2 and z <= currentCamera.z + 2 then
						local cell = ""
						for y = 1,ay do
							local abz = currentWorkspace[x][y][z]
							if type(abz) == "string" and abz ~= graphics.cells.Cells["Air"].i then
								cell = abz
								-- distance shade
								if y == ay then
									local name = graphics.getNameDshade(abz)
									if graphics.cells.Cells[name] then
										cell = graphics.cells.Cells[name].dshade
									end
								end
								break
							elseif type(abz) == "string" then
								cell = graphics.cells.Cells["Air"].i
							end	
						end
						string = string.." "..cell
					end
				end
				print(string)
				string = ""
			end
		end
	end
end
function graphics.character(x,y,z,health,specialparams)
	local char = {}
	char.x = x
	char.y = y
	char.z = z
	char.health = health
	char.params = specialparams
	return char
end

function graphics.input()
	local input = io.read()
	while input == "" or input == " " do
		input = io.read()
	end
	return input
end

return graphics