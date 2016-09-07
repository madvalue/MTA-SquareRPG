--[[
	Praca koszenia trawników
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local job_name = "Koszenie trawników"
local job_emp = "kosiciel trawników"
local job_desc = "Wymagania:\\n[+]Brak\\n\\nPraca polega na koszeniu trawników na terenie miasta San Fierro, wynagrodzenie nadawane jest automatycznie i można je odebrać u pracodawcy w dowolnym momęcie"
local job_uid = 3
local job_kat = false

local starts = {
	{ped={-2404.90625, 690.27734375, 35.163887023926, 90}, marker={-2405.607421875, 690.283203125, 35.163715362549}},
}

addEventHandler("onResourceStart", resourceRoot, function ()
	for i,v in ipairs(starts) do
		local x1,y1,z1, rz = unpack(v.ped)
		local ped = createPed(165, x1, y1, z1, rz)
		setElementData(ped, "name", "Pracodawca")
		
		local x2,y2,z2 = unpack(v.marker)
		local marker = createMarker(x2, y2, z2-1, "cylinder", 0.7, 255, 255, 255, 100)
		
		local cs = createColSphere(x2, y2, z2, 1)
		
		addEventHandler("onColShapeHit", cs, markerHit)
		addEventHandler("onColShapeLeave", cs, markerLeave)
	end
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

addEvent("assignPlayerKosiarka", true)
addEventHandler("assignPlayerKosiarka", getRootElement(), function ()
	if getElementData(source, "job:veh") then
		exports.rpg_noti:createNotification(source, "error", "Przydzielono Ci już jeden pojazd służbowy")
		return
	end
	local x,y,z,rz = -2406.154296875, 681.9873046875, 35.163581848145, 90
	local veh = createVehicle(572, x, y, z, 0, 0, rz)
	setElementData(veh, "veh:job", job_uid)
	setElementData(veh, "job:user", source)
	setElementData(source, "job:veh", veh)
	warpPedIntoVehicle(source, veh)
	setElementParent(veh, source)
	triggerClientEvent(source, "startKoszenie", source)
end)

addEventHandler("onPlayerQuit", getRootElement(), function ()
	if getElementData(source, "user:job") ~= job_uid then return end
	if not getElementData(source, "job:veh") then return end
	local veh = getElementData(source, "job:veh")
	local shape = getElementData(veh, "stop:shape")
	if shape then
		destroyElement(shape)
	end
	destroyElement(veh)
end)

addEventHandler("onVehicleStartEnter", getRootElement(), function (plr)
	if getElementData(source, "veh:job") ~= job_uid then return end
	if getElementData(source, "job:user") ~= plr then cancelEvent() end
end)

addEventHandler("onVehicleEnter", getRootElement(), function (plr, seat)
	if getElementData(source, "veh:job") ~= job_uid then return end
	if seat ~= 0 then return end
	if getElementData(source, "job:user") ~= plr then return end
	local cs = getElementData(source, "stop:shape")
	triggerClientEvent(plr, "startKoszenie", plr)
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
	triggerClientEvent(plr, "stopKoszenie", plr)
	exports.rpg_noti:createNotification(plr, "info", "Opuściłeś swój pojazd, jeśli odejdziesz zbyt daleko zostanie on usunięty")
	--[[destroyElement(source)
	triggerClientEvent(plr, "destroyPunkty", plr)]]
end)

function stopPraca(hit, dim)
	local veh = getElementData(source, "stop:veh")
	if getElementData(hit, "job:veh") ~= veh then return end
	destroyElement(veh)
	if isElement(source) then
		destroyElement(cs)
	end
	setElementData(hit, "job:veh", false)
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
end)