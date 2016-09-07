--[[
	Komisy samochodowe
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local vehicles = {}
local komis_shapes = {}
local slots = {
	{-2101.43359375, -1.2392578125, 35.3203125, 17.132995605469, model=604, dmax=95000, dmin=70000, price=2439},
	{-2120.8388671875, -3.361328125, 35.3203125, 288.1840209960, model=543, dmax=118000, dmin=76000, price=5178},
	{-2121.228515625, 15.5625, 35.3203125, 187.06980895996, model=getVehicleModelFromName("Virgo"), dmax=130000, dmin=85000, price=3129},
	{-2109.54296875, -2.482421875, 35.060146331787, 87.648345947266, model=getVehicleModelFromName("Oceanic"), dmax=125000, dmin=80000, price=1759},
}

addEventHandler("onResourceStart", resourceRoot, function ()
	for i,v in ipairs(slots) do
		komis_shapes[i] = createColSphere(v[1], v[2], v[3], 3)
		setElementData(komis_shapes[i], "i", i)
		createKomisVehicle(i)
		
		addEventHandler("onColShapeHit", komis_shapes[i], function (hit,dim)
			if getElementType(hit) == "player" and getElementData(komis_shapes[i], "komis:veh") then
				outputChatBox("Aby zakupić ten pojazd użyj komendy /kuppojazd", hit, 230, 230, 230)
			end
		end)
		
	end
end)

addCommandHandler("kuppojazd", function (plr, cmd)
	local shape = isPlayerInVehicleColShape(plr)
	if not shape then return end
	local veh = getElementData(shape, "komis:veh")
	if not veh then return end
	local slot = getElementData(shape, "komis:slot")
	
	local price = vehicles[slot].price
	local money = getElementData(plr, "user:money")
	if price > money then
		exports.rpg_noti:createNotification(plr, "error", "Nie stać Cię na zakup tego pojazdu")
		return
	end
	setElementData(plr, "user:money", money-price)
	
	local x,y,z = getElementPosition(veh)
	local rx,ry,rz = getElementRotation(veh)
	local i = getElementInterior(veh)
	local d = getElementDimension(veh)
	local pos = x..", "..y..", "..z..", "..rx..", "..ry..", "..rz..", "..i..", "..d
	
	local r1,g1,b1, r2,g2,b2, r3,g3,b3, r4,g4,b4 = getVehicleColor(veh, true)
	local color1 = r1..", "..g1..", "..b1
	local color2 = r2..", "..g2..", "..b2
	local color3 = r3..", "..g3..", "..b3
	local color4 = r4..", "..g4..", "..b4
	
	local owner = getElementData(plr, "user:uid")
	local model = getElementModel(veh)
	
	local dist = vehicles[slot].dist
	
	destroyElement(veh)
	setElementData(shape, "komis:veh", false)
	
	local q, num, id = exports.rpg_mysql:mysql_query("INSERT INTO rpg_vehicles SET pos=?, owner=?, przecho=0, color1=?, color2=?, color3=?, color4=?, model=?, distance=?", pos, owner, color1, color2, color3, color4, model, dist)
	if q then
		local veh = exports.rpg_vehicles:createNewVehicle(id)
		createKomisVehicle(slot)
		exports.rpg_noti:createNotification(plr, "info", "Gratulacje! Zakupujesz swój pojazd!")
		destroyElement(vehicles[slot].t)
		warpPedIntoVehicle(plr, veh, 0)
	else
		outputChatBox("Wystąpił problem podczas kupna pojazdu [ERR12]", plr, 255, 0, 0)
	end
end)

function createKomisVehicle(slot)
	if #getElementsWithinColShape(komis_shapes[slot]) > 0 then setTimer(createKomisVehicle, 30000, 1, slot) return end
	
	vehicles[slot] = {}

	vehicles[slot].dist = math.random(slots[slot].dmin, slots[slot].dmax)
	vehicles[slot].price = slots[slot].price
	
	vehicles[slot].veh = createVehicle(slots[slot].model, slots[slot][1], slots[slot][2], slots[slot][3], 0, 0, slots[slot][4])
	setElementFrozen(vehicles[slot].veh, true)
	setVehicleDamageProof(vehicles[slot].veh, true)
	
	setElementData(komis_shapes[slot], "komis:veh", vehicles[slot].veh)
	setElementData(komis_shapes[slot], "komis:slot", slot)
	setElementData(vehicles[slot].veh, "komis:veh", true)
	
	vehicles[slot].t = createElement("text")
	setElementPosition(vehicles[slot].t,  slots[slot][1], slots[slot][2], slots[slot][3]+2)
	setElementData(vehicles[slot].t, "text", exports.rpg_vehicles:getVehicleCustomName(slots[slot].model).."\nKoszt: $"..slots[slot].price.."\nPrzebieg: "..vehicles[slot].dist.."km")
end

function isPlayerInVehicleColShape(player)
	for i,v in ipairs(komis_shapes) do
		if isElementWithinColShape(player, v) then return v end
	end
	return false
end