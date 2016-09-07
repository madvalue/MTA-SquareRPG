--[[
	System pojazdów oparty o MySQL
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
function loadVehicles()
	local q = exports.rpg_mysql:mysql_query("SELECT * FROM rpg_vehicles WHERE przecho=0")
	
	setModelHandling(491, "maxVelocity", 120)
	setModelHandling(491, "engineAcceleration", 6)
	
	for i,v in ipairs(q) do
		makeVehicle(v)
	end
end
addEventHandler("onResourceStart", resourceRoot, loadVehicles)

function makeVehicle(v)
	local pos = split(v.pos, ",")
	local veh = createVehicle(v.model, pos[1], pos[2], pos[3], pos[4], pos[5], pos[6])
	setElementInterior(veh, pos[7])
	setElementDimension(veh, pos[8])
		
	local color1 = split(v.color1, ",")
	local color2 = split(v.color2, ",")
	local color3 = split(v.color3, ",")
	local color4 = split(v.color4, ",")
		
	setVehicleColor(veh, color1[1], color1[2], color1[3], color1[4], color2[1], color2[2], color2[3], color2[4], color3[1], color3[2], color3[3], color3[4], color4[1], color4[2], color4[3], color4[4])
		
	setElementData(veh, "veh:uid", v.uid)
	setElementData(veh, "veh:owner", v.owner)
	setElementData(veh, "veh:distance", v.distance)
		
	if string.len(v.plate) < 1 then -- Nie ma customowej rejestracji, ustawiamy domyślną
		setVehiclePlateText(veh, "SQ"..string.format("%6.5d", v.uid))
	else
		setVehiclePlateText(veh, v.plate)
	end
		
	local upgrades = split(v.upgrades, ",")
	for i=1,#upgrades do
		addVehicleUpgrade(veh, upgrades[i])
	end
	
	return veh
end

function saveVehicles()
	for i,v in ipairs(getElementsByType("vehicle")) do
		saveVehicle(v)
	end
end
addEventHandler("onResourceStop", resourceRoot, saveVehicles)

function saveVehicle(v)
	local uid = getElementData(v, "veh:uid")
	if uid then
		local distance = getElementData(v, "veh:distance")
		local r1,g1,b1, r2,g2,b2, r3,g3,b3, r4,g4,b4 = getVehicleColor(v, true)
		local x,y,z = getElementPosition(v)
		local rx,ry,rz = getElementRotation(v)
		local int = getElementInterior(v)
		local dim = getElementDimension(v)
		local color1 = r1..", "..g1..", "..b1
		local color2 = r2..", "..g2..", "..b2
		local color3 = r3..", "..g3..", "..b3
		local color4 = r4..", "..g4..", "..b4
		local pos = x..", "..y..", "..z..", "..rx..", "..ry..", "..rz..", "..int..", "..dim
		local q = exports.rpg_mysql:mysql_query("UPDATE rpg_vehicles SET pos=?, przecho=0, distance=?, color1=?, color2=?, color3=?, color4=? WHERE uid=?", pos, distance, color1, color2, color3, color4, uid)
		if not q then
			outputDebugString("[rpg_vehicles] Wystapił problem z zapisywaniem pojazdu UID "..uid)
		end
	end
end

addEventHandler("onVehicleStartEnter", getRootElement(), function (plr, seat, jacked, door)
	--if seat == 0 and getVehicleOccupant(source, 0)  then cancelEvent() end
	if getElementData(source, "veh:uid") then
		if (getElementData(plr, "user:uid") ~= getElementData(source, "veh:owner")) and seat == 0 then
			exports.rpg_noti:createNotification(plr, "error", "Nie masz dostepu do tego pojazdu")
			cancelEvent()
		end
	end
end)

addEventHandler("onVehicleDamage", getRootElement(), function ()
	if getElementHealth(source) < 300 then
		setElementHealth(source, 310)
	end
end)

function createNewVehicle(uid)
	local q= exports.rpg_mysql:mysql_query("SELECT * FROM rpg_vehicles WHERE uid=?", uid)
	local veh = makeVehicle(q[1])
	return veh
end

