--[[
	Egzamin na prawo jazdy
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local starty = {
	{-2025.5048828125, -114.5185546875, 1035.171875, 3, 2},
}

addEventHandler("onResourceStart", resourceRoot, function ()
	for i,v in ipairs(starty) do
		local marker = createMarker(v[1], v[2], v[3]-1, "cylinder", 1, 255, 200, 0, 150)
		setElementInterior(marker, v[4])
		setElementDimension(marker, v[5])
		
		local cs = createColSphere(v[1], v[2], v[3], 1)
		setElementInterior(cs, v[4])
		setElementDimension(cs, v[5])
		
		local t = createElement("text")
		setElementPosition(t, v[1], v[2], v[3]+1)
		setElementData(t, "text", "Egzaminy")
		setElementInterior(t, v[4])
		setElementDimension(t, v[5])
		
		addEventHandler("onColShapeHit", cs, markerHit)
		addEventHandler("onColShapeLeave", cs, markerLeave)
	end
end)

function markerHit(hit)
	if getElementType(hit) ~= "player" then return end
	triggerClientEvent(hit, "createPrawkoWindow", hit)
end

function markerLeave(hit)
	if getElementType(hit) ~= "player" then return end
	triggerClientEvent(hit, "closeWindow", hit)
end

function createPrawkoVehA()
	local veh = createVehicle(586, -2047.0244140625, -96.7998046875, 34.684188842773)
	setElementData(source, "pj:veh", veh)
	setElementData(veh, "pj:user", source)
	warpPedIntoVehicle(source, veh)
	setElementInterior(source, 0)
	setElementDimension(source, 0)
	addEventHandler("onVehicleStartExit", veh, przerwijEgzamin1)
	addEventHandler("onVehicleExit", veh, przerwijEgzamin1)
	addEventHandler("onVehicleDamage", veh, przerwijEgzamin2)
	setElementParent(veh, source)
end
addEvent("createPrawkoVehA", true)
addEventHandler("createPrawkoVehA", getRootElement(), createPrawkoVehA)

function destroyPrawkoVehA()
	local veh = getElementData(source, "pj:veh")
	if isElement(veh) then
		removeEventHandler("onVehicleExit", veh, przerwijEgzamin1)
		removePedFromVehicle(source)
		destroyElement(veh)
	end
end
addEvent("destroyPrawkoVehA", true)
addEventHandler("destroyPrawkoVehA", getRootElement(), destroyPrawkoVehA)

function createPrawkoVehB()
	local veh = createVehicle(516, -2047.0244140625, -96.7998046875, 34.684188842773)
	setElementData(source, "pj:veh", veh)
	setElementData(veh, "pj:user", source)
	warpPedIntoVehicle(source, veh)
	setElementInterior(source, 0)
	setElementDimension(source, 0)
	addEventHandler("onVehicleStartExit", veh, przerwijEgzamin1)
	addEventHandler("onVehicleExit", veh, przerwijEgzamin1)
	addEventHandler("onVehicleDamage", veh, przerwijEgzamin2)
	setElementParent(veh, source)
end
addEvent("createPrawkoVehB", true)
addEventHandler("createPrawkoVehB", getRootElement(), createPrawkoVehB)

function destroyPrawkoVehB()
	local veh = getElementData(source, "pj:veh")
	if isElement(veh) then
		removeEventHandler("onVehicleExit", veh, przerwijEgzamin1)
		removePedFromVehicle(source)
		destroyElement(veh)
	end
end
addEvent("destroyPrawkoVehB", true)
addEventHandler("destroyPrawkoVehB", getRootElement(), destroyPrawkoVehB)

function createPrawkoVehC()
	local veh = createVehicle(414, -2047.0244140625, -96.7998046875, 34.684188842773)
	setElementData(source, "pj:veh", veh)
	setElementData(veh, "pj:user", source)
	warpPedIntoVehicle(source, veh)
	setElementInterior(source, 0)
	setElementDimension(source, 0)
	addEventHandler("onVehicleStartExit", veh, przerwijEgzamin1)
	addEventHandler("onVehicleExit", veh, przerwijEgzamin1)
	addEventHandler("onVehicleDamage", veh, przerwijEgzamin2)
	setElementParent(veh, source)
end
addEvent("createPrawkoVehC", true)
addEventHandler("createPrawkoVehC", getRootElement(), createPrawkoVehC)

function destroyPrawkoVehC()
	local veh = getElementData(source, "pj:veh")
	if isElement(veh) then
		removeEventHandler("onVehicleExit", veh, przerwijEgzamin1)
		removePedFromVehicle(source)
		destroyElement(veh)
	end
end
addEvent("destroyPrawkoVehC", true)
addEventHandler("destroyPrawkoVehC", getRootElement(), destroyPrawkoVehC)

function backToSchool(plr)
	setElementPosition(plr, -2032.83984375, -117.384765625, 1035.171875)
	setElementRotation(plr, 0, 0, 270)
	setElementInterior(plr, 3)
	setElementDimension(plr, 2)
end
addEvent("backToSchool", true)
addEventHandler("backToSchool", getRootElement(), backToSchool)

function givePrawkoA()
	setElementData(source, "user:pjA", 1)
	exports.rpg_mysql:mysql_query("UPDATE rpg_accounts SET pjA=1 WHERE uid=?", getElementData(source, "user:uid"))
end
addEvent("givePrawkoA", true)
addEventHandler("givePrawkoA", getRootElement(), givePrawkoA)

function givePrawkoB()
	setElementData(source, "user:pjB", 1)
	exports.rpg_mysql:mysql_query("UPDATE rpg_accounts SET pjB=1 WHERE uid=?", getElementData(source, "user:uid"))
end
addEvent("givePrawkoB", true)
addEventHandler("givePrawkoB", getRootElement(), givePrawkoB)

function givePrawkoC()
	setElementData(source, "user:pjC", 1)
	exports.rpg_mysql:mysql_query("UPDATE rpg_accounts SET pjC=1 WHERE uid=?", getElementData(source, "user:uid"))
end
addEvent("givePrawkoC", true)
addEventHandler("givePrawkoC", getRootElement(), givePrawkoC)

function przerwijEgzamin1(plr, seat)
	if seat ~= 0 then return end
	local veh = getElementData(plr, "pj:veh")
	if isElement(veh) then
		removeEventHandler("onVehicleExit", veh, przerwijEgzamin1)
		removePedFromVehicle(plr)
		destroyElement(veh)
	end
	backToSchool(plr)
	exports.rpg_noti:createNotification(plr, "info", "Opuszczasz swój pojazd, oblewasz egzamin")
	triggerClientEvent(plr, "destroyPunkt", plr)
end

function przerwijEgzamin2(loss)
	if loss < 50 then return end
	local plr = getElementData(source, "pj:user")
	removePedFromVehicle(plr)
	local veh = getElementData(plr, "pj:veh")
	if isElement(veh) then
		destroyElement(veh)
	end
	backToSchool(plr)
	exports.rpg_noti:createNotification(plr, "info", "Uszkadzasz swój pojazd zbyt mocno, oblewasz egzamin")
	triggerClientEvent(plr, "destroyPunkt", plr)
end