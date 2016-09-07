--[[
	Praca czyszczenia ulic
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
	
	Regiony:
	1 > San Fierro
]]
local job_name = "Czyszczenie ulic"
local job_emp = "czyściciel ulic"
local job_desc = "Wymagania:\\n[+]Kategoria B\\n\\nPraca polega na czyszczeniu ulic poprzez jazdę od po wyznaczonej trasie od czerwonego do zielonego punktu, aktualna trasa oznaczona jest czerwonym blipiem na radarze. Wynagrodzenie możesz odebrać u pracodawcy w dowolnym momęcie"
local job_uid = 1
local job_kat = "pjB"

local region = 1
local respawnTime = 5 -- Czas w sekdunach, po którym na miejscu pojawi się nowy sweeperek

local markers = {}
local shapes = {}

local starts = {
	{ped={-1690.59473, 1253.08093, 7.22716, 40, 0, 0}, marker={-1691.22607, 1253.66663, 7.22600, 0, 0}, region=1}, -- San Fierro
}

local slots = {
	{-1718.05481, 1278.91541, 7.21604, 315}, -- San Fierro
	{-1715.14343, 1276.02100, 7.21616, 315}, -- San Fierro
	{-1712.35364, 1273.13159, 7.21548, 315}, -- San Fierro
	{-1709.70203, 1270.58130, 7.21617, 315}, -- San Fierro
	{-1707.09473, 1267.95386, 7.21603, 315}, -- San Fierro
	{-1704.24817, 1265.26917, 7.21714, 315}, -- San Fierro
}

addEventHandler("onResourceStart", resourceRoot, function ()
	for i,v in ipairs(starts) do
		local x1,y1,z1,rz,i1,d1 = unpack(v.ped)
		local ped = createPed(165, x1, y1, z1, rz)
		setElementInterior(ped, i1)
		setElementDimension(ped, d1)
		setElementFrozen(ped, true)
		setElementData(ped, "name", "Pracodawca")

		local x2,y2,z2,i2,d2 = unpack(v.marker)
		local marker = createMarker(x2, y2, z2-1, "cylinder", 0.7, 255, 255, 255, 100)
		setElementInterior(marker, i2)
		setElementDimension(marker, d2)
			
		local cs = createColSphere(x2, y2, z2, 1)
		setElementInterior(cs, i2)
		setElementDimension(cs, d2)
		
		addEventHandler("onColShapeHit", cs, markerHit)
		addEventHandler("onColShapeLeave", cs, markerLeave)
	end
	
	for i,v in ipairs(slots) do
		shapes[i] = createColSphere(v[1], v[2], v[3], 2.6)
		setElementData(shapes[i], "slot", i)
		createJobVehicle(i)
		addEventHandler("onColShapeLeave", shapes[i], leaveSlot)
	end
	
	local t = createElement("text")
	setElementPosition(t, -1711.00537, 1271.65552, 10.21416)
	setElementData(t, "text", "Zakaz parkowania - miejsce spawnu pojazdów")
	setElementData(t, "scale", 2)
end)

addEventHandler("onVehicleStartEnter", getRootElement(), function (plr, seat)
	if getElementData(source, "veh:job") ~= job_uid then return end
	if seat ~= 0 then return end
	if getElementData(plr, "user:job") ~= job_uid then
		exports.rpg_noti:createNotification(plr, "error", "Ten pojazd dostępny jest tylko dla zatrudnionych")
		cancelEvent()
	end
	if not getElementData(source, "job:user") then return end
	if getElementData(source, "job:user") ~= plr then
		cancelEvent()
	end
end)

function createJobVehicle(slot)
	local x,y,z,rz = slots[slot][1], slots[slot][2], slots[slot][3], slots[slot][4]
	--outputChatBox("Elements in shape: "..(#getElementsWithinColShape(shapes[slot])))
	if #getElementsWithinColShape(shapes[slot]) > 0 then setTimer(createJobVehicle, 5000, 1, slot) return end
	local veh = createVehicle(574, x, y, z, 0, 0, rz)
	setElementData(veh, "veh:job", job_uid)
	setElementFrozen(veh, true)
	setVehicleColor(veh, 255, 255, 255)
	addEventHandler("onVehicleEnter", veh, startPraca)
end

function leaveSlot(hit, dim)
	if getElementType(hit) ~= "vehicle" then return end
	if getElementData(hit, "veh:job") ~= job_uid then return end
	local i = getElementData(source, "slot")
	setTimer(createJobVehicle, 5000, 1, i)
end

addEventHandler("onVehicleEnter", getRootElement(), function (plr, seat)
	if getElementData(source, "veh:job") ~= job_uid then return end
	if seat ~= 0 then return end
	if getElementData(source, "job:user") ~= plr then return end
	local cs = getElementData(source, "stop:shape")
	if not cs then return end
	destroyElement(cs)
end)

addEventHandler("onVehicleExit", getRootElement(), function (plr, seat)
	if getElementData(source, "veh:job") ~= job_uid then return end
	if seat ~= 0 then return end
	if getElementData(source, "job:user") ~= plr then return end
	local x,y,z = getElementPosition(source)
	local cs = createColSphere(x,y,z,25)
	attachElements(cs, source)
	setElementData(source, "stop:shape", cs)
	setElementData(cs, "stop:veh", source)
	setElementParent(cs, source)
	addEventHandler("onColShapeLeave", cs, stopPraca)
	exports.rpg_noti:createNotification(plr, "info", "Opuściłeś swój pojazd, jeśli odejdziesz zbyt daleko zostanie on usunięty")
	--[[destroyElement(source)
	triggerClientEvent(plr, "destroyPunkty", plr)]]
end)

function stopPraca(hit, dim)
	local veh = getElementData(source, "stop:veh")
	if getElementData(hit, "job:veh") ~= veh then return end
	destroyElement(veh)
	triggerClientEvent(hit, "sweeperki:destroyPunkty", hit)
	if isElement(source) then
		destroyElement(source)
	end
	setElementData(hit, "job:veh", false)
end

addEventHandler("onPlayerResign", getRootElement(), function (plr, job)
	if job ~= job_uid then return end
	local veh = getElementData(plr, "job:veh")
	if not veh then return end
	local cs = getElementData(veh, "stop:shape")
	if cs then
		destroyElement(cs)
	end
	destroyElement(veh)
	triggerClientEvent(plr, "sweeperki:destroyPunkty", plr)
end)

addEventHandler("onPlayerQuit", getRootElement(), function ()
	if getElementData(source, "user:job") ~= job_uid then return end
	local veh = getElementData(source, "job:veh")
	if not veh then return end
	local cs = getElementData(veh, "stop:shape")
	if cs then
		destroyElement(cs)
	end
	destroyElement(veh)
	triggerClientEvent(source, "sweeperki:destroyPunkty", source)
end)

function findFreeSlot()
	local slot = 1
	for i,v in ipairs(shapes) do
		if #getElementsWithinColShape(v) < 1 then
			return slot
		end
		slot = slot + 1
	end
	return false
end

function startPraca(plr,seat)
	if seat ~= 0 then return end
	if getElementData(source, "job:user") then return end
	
	setElementData(source, "job:user", plr)
	setElementData(plr, "job:veh", source)
	
	setElementFrozen(source, false)
	setElementParent(source, plr)
	
	triggerClientEvent(plr, "sweeperki:losujLokacje", plr)
end

function markerHit(hit, dim)
	if getElementType(hit) ~= "player" then return end
	if isPedInVehicle(hit) then return end
	triggerClientEvent(hit, "createJobsWindow", hit, {job_name, job_desc, job_uid, job_emp, job_kat})
end

function markerLeave(hit, dim)
	if getElementType(hit) ~= "player" then return end
	if isPedInVehicle(hit) then return end
	triggerClientEvent(hit, "destroyJobsWindow", hit)
end