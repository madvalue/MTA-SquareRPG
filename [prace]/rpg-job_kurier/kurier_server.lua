--[[
	Praca kuriera
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
	
	Regiony:
	1 > San Fierro
]]
local job_name = "Kurier"
local job_emp = "kurier"
local job_desc = "Wymagania:\\n[+]Kategoria C\\n\\nPraca polega na dostarczaniu paczek do celów rozmieszczonych na terenie San Fierro. Wynagrodzenie możesz odebrać w dowolnym momęcie u pracodawcy"
local job_uid = 2
local job_kat = "pjC"

local shapes = {}

local starts = {
	{ped={-2286.109375, -176.3134765625, 35.3203125, 35.1650390625}, marker={-2286.93359375, -175.3740234375, 35.3203125}, int=0, dim=0}, -- San Fierro
}

local slots = {
	{-2324.86328125, -172.6162109375, 35.3203125, 0, region=1},
	{-2331.86328125, -172.6162109375, 35.3203125, 0, region=1},
	{-2338.86328125, -172.6162109375, 35.3203125, 0, region=1},
	{-2345.86328125, -171.6162109375, 35.3203125, 0, region=1},
	{-2352.9404296875, -142.333984375, 35.3203125, 270, region=1},
	{-2352.9404296875, -149.333984375, 35.3203125, 270, region=1},
	{-2352.9404296875, -156.333984375, 35.3203125, 270, region=1},
	{-2352.9404296875, -163.333984375, 35.3203125, 270, region=1},
}

addEventHandler("onResourceStart", resourceRoot, function ()
	for i,v in ipairs(starts) do
		local x1,y1,z1,rz = unpack(v.ped)
		local ped = createPed(165, x1, y1, z1, rz)
		setElementData(ped, "name", "Pracodawca")
		setElementInterior(ped, v.int)
		setElementDimension(ped, v.dim)
		setElementFrozen(ped, true)
		
		local x2,y2,z2 = unpack(v.marker)
		local marker = createMarker(x2, y2, z2-1, "cylinder", 0.7, 255, 255, 255, 100)
		
		local cs = createColSphere(x2,y2,z2,0.7)
		addEventHandler("onColShapeHit", cs, markerHit)
		addEventHandler("onColShapeLeave", cs, markerLeave)
	end
	
	for i,v in ipairs(slots) do
		shapes[i] = createColSphere(v[1], v[2], v[3], 4)
		setElementData(shapes[i], "i", i)
		addEventHandler("onColShapeLeave", shapes[i], leaveSlot)
	end
	
	for i,v in ipairs(slots) do
		createJobVehicle(i)
	end
end)

addEventHandler("onVehicleExit", getRootElement(), function (plr, seat)
	if seat ~= 0 then return end
	if getElementData(source, "veh:job") ~= job_uid then return end
	if getElementData(source, "job:user") ~= plr then return end
	local x,y,z = getElementPosition(source)
	local cs = createColSphere(x, y, z, 25)
	attachElements(cs, source)
	setElementParent(cs, source)
	setElementData(source, "stop:shape", cs)
	addEventHandler("onColShapeLeave", cs, stopPraca)
	exports.rpg_noti:createNotification(plr, "info", "Opuściłeś swój pojazd, jeśli odejdziesz zbyt daleko zostanie on usunięty")
end)

addEventHandler("onVehicleEnter", getRootElement(), function (plr, seat)
	if seat ~= 0 then return end
	if getElementData(source, "veh:job") ~= job_uid then return end
	if getElementData(source, "job:user") ~= plr then return end
	local cs = getElementData(source, "stop:shape")
	if not cs then return end	
	destroyElement(cs)
	setElementData(source, "stop:shape", false)
end)

function stopPraca(hit)
	local veh = getElementData(hit, "job:veh")
	if getElementData(hit, "job:veh") ~= veh then return end
	if not veh then return end
	destroyElement(source)
	destroyElement(veh)
	setElementData(hit, "job:veh", false)
	triggerClientEvent(hit, "kurier:destroyPunkt", hit)
end

addEventHandler("onVehicleStartEnter", getRootElement(), function (plr, seat)
	if getElementData(source, "veh:job") ~= job_uid then return end
	if (getElementData(plr, "job:veh") or (getElementData(plr, "job:veh") ~= false)) and (getElementData(source, "job:user") ~= plr) then
		exports.rpg_noti:createNotification(plr, "error", "Został ci już przydzielony jeden pojazd służbowy")
		cancelEvent()
	end
	if (getElementData(plr, "user:job") ~= getElementData(source, "veh:job")) then
		cancelEvent()
	end
end)

function leaveSlot(hit, dim)
	if getElementType(hit) ~= "vehicle" then return end
	if getElementData(hit, "veh:job") ~= job_uid then return end
	local i = getElementData(source, "i")
	setTimer(createJobVehicle, 5000, 1, i)
end

function createJobVehicle(slot)
	local x,y,z,rz = slots[slot][1], slots[slot][2], slots[slot][3], slots[slot][4]
	--outputChatBox("Elements in shape: "..(#getElementsWithinColShape(shapes[slot])))
	if #getElementsWithinColShape(shapes[slot]) > 0 then setTimer(createJobVehicle, 5000, 1, slot) return end
	local veh = createVehicle(498, x, y, z, 0, 0, rz)
	setElementData(veh, "veh:job", job_uid)
	setElementFrozen(veh, true)
	setVehicleColor(veh, 255, 200, 0, 0, 0, 0)
	addEventHandler("onVehicleEnter", veh, startPraca)
end

function startPraca(plr,seat)
	if seat ~= 0 then return end
	if getElementData(source, "job:user") then return end
	
	setElementData(source, "job:user", plr)
	setElementData(plr, "job:veh", source)
	
	setElementFrozen(source, false)
	setElementParent(source, plr)
	
	triggerClientEvent(plr, "kurier:losujPunkt", plr)
end

addEventHandler("onPlayerResign", getRootElement(), function (plr, job)
	if job ~= job_uid then return end
	
	local veh = getElementData(plr, "job:veh")
	if veh then -- Gracz ma swój pojazd służbowy
		local shape = getElementData(veh, "stop:shape")
		if isElement(shape) then
			destroyElement(shape)
		end
		
		destroyElement(veh)
	end
	
	setElementData(plr, "job:veh", false)
	
	triggerClientEvent(plr, "kurier:destroyPunkt", plr)
end)

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