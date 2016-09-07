--[[
	Przechowywalnie
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local marker_odbierz = {-2431.1572265625, 1029.458984375, 50.390625}
local marker_wyjazd = {-2425.552734375, 1032.7470703125, 50.39062, 270}
local marker_wjazd = {-2437.6416015625, 1032.091796875, 50.3906255}

addEventHandler("onResourceStart", resourceRoot, function ()
	local x1,y1,z1 = unpack(marker_odbierz)
	local cs_1 = createColSphere(x1, y1, z1, 1)
	local m_1 = createMarker(x1, y1, z1-1, "cylinder", 1, 255, 200, 0, 100)
	local t_1 = createElement("text")
	setElementPosition(t_1, x1, y1, z1+1)
	setElementData(t_1, "text", "Odbiór pojazdów")
	
	local x2,y2,z2 = unpack(marker_wyjazd)
	cs_2 = createColSphere(x2, y2, z2, 3)
	
	local x3,y3,z3 = unpack(marker_wjazd)
	local cs_3 = createColSphere(x3, y3, z3, 3)
	local m_3 = createMarker(x3, y3, z3-1, "cylinder", 5, 0, 0, 0, 100)
	local t_3 = createElement("text")
	setElementPosition(t_3, x3, y3, z3+3)
	setElementData(t_3, "text", "Pozostawianie pojazdów")
	
	addEventHandler("onColShapeHit", cs_1, pokazListe)
	addEventHandler("onColShapeLeave", cs_1, usunListe)
	addEventHandler("onColShapeHit", cs_3, oddajPojazd)
end)

function pokazListe(hit, dim)
	if getElementType(hit) ~= "player" then return end
	if isPedInVehicle(hit) then return end
	
	local q = exports.rpg_mysql:mysql_query("SELECT * FROM rpg_vehicles WHERE owner=? AND przecho=1", getElementData(hit, "user:uid"))
	if #q < 1 then
		exports.rpg_noti:createNotification(hit, "info", "Nie posiadasz pojazdów w przechowywalni")
		return
	end
	triggerClientEvent(hit, "showPrzechoWindow", hit, q)
end

function usunListe(hit, dim)
	triggerClientEvent(hit, "destroyPrzechoWindow", hit)
end

function odbierzPojazd(player, uid)
	if #getElementsWithinColShape(cs_2, "vehicle") > 0 then
		exports.rpg_noti:createNotification(player, "info", "Coś blokuje wyjazd - odebranie pojazdu niemożliwe")
		return
	end
	local veh = exports.rpg_vehicles:createNewVehicle(uid)
	local x2,y2,z2,rz = unpack(marker_wyjazd)
	setElementPosition(veh, x2, y2, z2)
	setElementRotation(veh, 0, 0, rz)
	warpPedIntoVehicle(player, veh)
	exports.rpg_mysql:mysql_query("UPDATE rpg_vehicles SET przecho=0 WHERE uid=?", uid)
end
addEvent("odbierzPojazd", true)
addEventHandler("odbierzPojazd", getRootElement(), odbierzPojazd)

function oddajPojazd(hit, dim)
	if not hit or not isElement(hit) then return end
	if getElementType(hit) ~= "player" then return end
	if not isPedInVehicle(hit) then return end
	local veh = getPedOccupiedVehicle(hit)
	local uid = getElementData(veh, "veh:uid")
	if not uid then return end
	exports.rpg_vehicles:saveVehicle(veh)
	local q,n,i = exports.rpg_mysql:mysql_query("UPDATE rpg_vehicles SET przecho=1 WHERE uid=?", uid)
	if q then
		removePedFromVehicle(hit)
		destroyElement(veh)
		exports.rpg_noti:createNotification(hit, "info", "Oddajesz swój pojazd do przechowywalni")
	else
		exports.rpg_noti:createNotification(hit, "error", "Wystapił problem podczas oddawania pojazdu do przechowywalni [ERR13]")
	end
end