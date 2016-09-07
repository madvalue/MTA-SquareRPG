--[[
	Praca koszenia trawników
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local sw, sh = guiGetScreenSize()
local x2,y2,z2
local skoszone = 0
local surface = 0
local money = 0.1 -- $$$ za 0.5 pola skoszonego :D
local noti = false

local grass = {9,10,11,12,13,14,15,16,17,20,80,81,82,115,116,117,118,119,120,121,122,125,129,146,147,148,149,150,151,152,153,160}

local vehm = {
	{-2406.064453125, 687.7880859375, 35.163604736328},
}

function createVehMarker()
	if getElementData(localPlayer, "user:job") ~= 3 then return end
	for i,v in ipairs(vehm) do
		local e = createElement("k:vehMarker")
		local marker = createMarker(v[1], v[2], v[3]-1, "cylinder", 1.5, 255, 200, 0, 50)
		local cs = createColSphere(v[1], v[2], v[3], 1)
		addEventHandler("onClientColShapeHit", cs, assignPlayerVehicle)
		setElementData(e, "marker", marker)
		setElementData(e, "shape", cs)
		local t = createElement("text")
		setElementData(e, "text", t)
		setElementPosition(t, v[1], v[2], v[3]+1)
		setElementData(t, "text", "Pojazd służbowy")
	end
end
addEventHandler("onClientResourceStart", resourceRoot, createVehMarker)
addEventHandler("onPlayerAccountLogin", getRootElement(), createVehMarker)
addEventHandler("onPlayerStartJob", getRootElement(), createVehMarker)

addEventHandler("onClientPlayerPayday", getRootElement(), function (money)
	skoszone = 0
	noti = false
end)

function destroyVehMarkers()
	if getElementData(localPlayer, "user:job") ~= 3 then return end
	if isPedInVehicle(localPlayer) then return end
	for i,v in ipairs(getElementsByType("k:vehMarker")) do
		local marker = getElementData(v, "marker")
		local shape = getElementData(v, "shape")
		local text = getElementData(v, "text")
		destroyElement(marker)
		destroyElement(shape)
		destroyElement(text)
		destroyElement(v)
	end
	setElementData(localPlayer, "job:veh", false)
end
addEventHandler("onPlayerResign", getRootElement(), destroyVehMarkers)

function assignPlayerVehicle(hit)
	if getElementType(hit) ~= "player" then return end
	if hit ~= localPlayer then return end
	if getElementData(localPlayer, "user:job") ~= 3 then return end -- Nie powinno się zdarzyć
	if getElementData(localPlayer, "job:veh") then return end
	triggerServerEvent("assignPlayerKosiarka", hit)
end


function koszenieRender()
	dxDrawEmptyRectangle(sw/2-150, sh/2+300, 300, 20, tocolor(0, 0, 0, 255), 3)
	dxDrawLine(sw/2-148,  sh/2+310, sw/2-(148-(296*(skoszone/100))), sh/2+310, tocolor(255, 200, 0, 255), 16)
	dxDrawText("Postęp koszenia...", sw/2-150-1, sh/2+300+1, sw/2+150, sh/2+320, tocolor(0, 0, 0, 255), 1, "sans", "center", "center")
	dxDrawText("Postęp koszenia...", sw/2-150+1, sh/2+300+1, sw/2+150, sh/2+320, tocolor(0, 0, 0, 255), 1, "sans", "center", "center")
	dxDrawText("Postęp koszenia...", sw/2-150-1, sh/2+300-1, sw/2+150, sh/2+320, tocolor(0, 0, 0, 255), 1, "sans", "center", "center")
	dxDrawText("Postęp koszenia...", sw/2-150+1, sh/2+300-1, sw/2+150, sh/2+320, tocolor(0, 0, 0, 255), 1, "sans", "center", "center")
	dxDrawText("Postęp koszenia...", sw/2-150, sh/2+300, sw/2+150, sh/2+320, tocolor(255, 255, 255, 255), 1, "sans", "center", "center")
end

function koszeniePreRender()
	if not isPlayerInVehicle(localPlayer) then return end
	local x1,y1,z1 = getElementPosition(localPlayer)
	if not x2 or not y2 or not z2 then
		x2,y2,z2 = getElementPosition(localPlayer)
	end
	local dist = getDistanceBetweenPoints3D(x1,y1,z1, x2,y2,z2)
	if dist > 10 then
		local material = getSurfaceVehicleIsOn(getPedOccupiedVehicle(localPlayer))
		x2,y2,z2 = getElementPosition(localPlayer)
		if isPlayerOnGrass(material) and skoszone < 100 then
			skoszone = skoszone + 0.5
			setElementData(localPlayer, "user:jobmoney", getElementData(localPlayer, "user:jobmoney") + money)
		end
		if skoszone >= 100 and not noti then
			exports.rpg_noti:createNotification("info", "Zapełniłeś postęp koszenia, odbierz wynagrodzenie u pracodawcy, aby kontynuować pracę")
			noti = true
		end
	end
end

addEvent("startKoszenie", true)
addEventHandler("startKoszenie", getRootElement(), function ()
	removeEventHandler("onClientRender", getRootElement(), koszenieRender)
	removeEventHandler("onClientPreRender", getRootElement(), koszeniePreRender)
	addEventHandler("onClientRender", getRootElement(), koszenieRender)
	addEventHandler("onClientPreRender", getRootElement(), koszeniePreRender)
end)

addEvent("stopKoszenie", true)
addEventHandler("stopKoszenie", getRootElement(), function ()
	removeEventHandler("onClientRender", getRootElement(), koszenieRender)
	removeEventHandler("onClientPreRender", getRootElement(), koszeniePreRender)
end)

function getSurfaceVehicleIsOn(vehicle)
    if isElement(vehicle) and isVehicleOnGround(vehicle) then 
        local cx, cy, cz = getElementPosition(vehicle)
        local gz = getGroundPosition(cx, cy, cz) - 0.001
        local hit, _, _, _, _, _, _, _, material = processLineOfSight(cx, cy, cz, cx, cy, gz, true, false, false) 
        if hit then
			surface = material or 0
            return material 
        end
    end
    return false 
end

function isPlayerOnGrass(material)
	for i,v in ipairs(grass) do
		if v == material then
			return true
		end
	end
	return false
end

function dxDrawEmptyRectangle(x,y,w,h,c,g)
	dxDrawLine(x,y,x+w,y,c, g)
	dxDrawLine(x,y+h,x+w,y+h,c,g)
	dxDrawLine(x,y,x,y+h,c,g)
	dxDrawLine(x+w,y,x+w,y+h,c,g)
end

setElementData(localPlayer, "job:veh", false)

fileDelete("kosiarki_client.lua")