--[[
	Praca kuriera
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local baza = {}
baza[1] = {-2315.3271484375, -151.90234375, 35.320312} -- To jest punkt 0 dla SF
local prevpunkt = 0
local punkt = 0
local marker,blip,cs
local hajs = 1.2 -- tyle za każde 25 metrów

local cele = {
	[1] = { -- San Fierro
		{-1921.48046875, 303.2421875, 41.115814208984},
		{-2093.4384765625, 94.9248046875, 35.386734008789},
		{-2098.646484375, -16.3505859375, 35.385810852051},
		{-1863.0185546875, -141.978515625, 11.966378211975},
		{-1820.69140625, -156.15625, 9.4729156494141},
		{-1724.0107421875, -119.931640625, 3.6120834350586},
		{-2103.2431640625, 654.4150390625, 52.435207366943},
		{-2124.5908203125, 655.0986328125, 52.434246063232},
		{-2157.8017578125, 654.8330078125, 52.435173034668},
		{-2461.578125, 787.027734375, 35.241622924805},
		{-2461.578125, 793.427734375, 35.241622924805},
		{-2461.578125, 780.427734375, 35.241622924805},
		{-2566.951171875, 556.1708984375, 14.531860351563},
		{-2664.6875, 235.9306640625, 4.4086260795593},
		{-2750.6005859375, 203.4169921875, 7.1047778129578},
		{-2729.8525390625, 77.4560546875, 4.4037351608276},
		{-2533.416015625, -19.2783203125, 16.492513656616},
		{-2460.1259765625, -139.8544921875, 25.936506271362},
		{-1959.9208984375, 616.853515625, 35.082794189453},
		{-1944.1904296875, 616.9013671875, 35.085182189941},
		{-1612.169921875, 1284.4404296875, 7.2541871070862},
		{-1741.865234375, 1425.2138671875, 7.2566981315613},
		{-1790.458984375, 1424.3310546875, 7.2545132637024},
		{-1834.80078125, 1424.42578125, 7.2538113594055},
		{-1871.103515625, 1415.814453125, 7.2486042976379},
		{-2480.666015625, 1070.4501953125, 55.846466064453},
		{-2472.9638671875, 1070.32421875, 55.855701446533},
		{-2465.22265625, 1070.3544921875, 55.861972808838},
		{-2458.4052734375, 1070.396484375, 55.856384277344},
		{-2438.0029296875, 1031.2744140625, 50.458728790283},
		{-2444.4638671875, 955.46484375, 45.369575500488},
	}
}

local function losujPunkt()
	local r = math.random(1, #cele[1])
	if r== prevpunt then
		losujPunkt()
		return
	end
	local x1,y1,z1 = cele[1][r][1],  cele[1][r][2], cele[1][r][3]
	local x2,y2,z2
	if prevpunkt == 0 then
		x2,y2,z2 = baza[1][1], baza[1][2], baza[1][3]
	else
		x2,y2,z2 = cele[1][prevpunkt][1],  cele[1][prevpunkt][2], cele[1][prevpunkt][3]
	end
	local dist = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	if dist < 50 then
		losujPunkt()
		return
	end
	prevpunkt = punkt
	punkt = r
	createPunkt(r)
end
addEvent("kurier:losujPunkt", true)
addEventHandler("kurier:losujPunkt", getRootElement(), losujPunkt)

function createPunkt(p)
	local x,y,z = cele[1][p][1],  cele[1][p][2], cele[1][p][3]
	marker = createMarker(x, y, z-1,"cylinder", 4, 255, 0, 0, 100)
	cs = createColSphere(x, y, z, 3)
	blip = createBlip(x, y, z, 41)
	addEventHandler("onClientColShapeHit", cs, hitPunkt)
end

function destroyPunkt()
	if isElement(marker) then
		destroyElement(marker)
	end
	if isElement(cs) then
		destroyElement(cs)
	end
	if isElement(blip) then
		destroyElement(blip)
	end
end
addEvent("kurier:destroyPunkt", true)
addEventHandler("kurier:destroyPunkt", getRootElement(), destroyPunkt)

function hitPunkt(hit)
	if getElementType(hit) ~= "vehicle" then return end
	local plr = getVehicleOccupant(hit, 0)
	if plr ~= localPlayer then return end
	local x1,y1,z1 = cele[1][punkt][1],  cele[1][punkt][2], cele[1][punkt][3]
	local x2,y2,z2
	if prevpunkt == 0 then
		x2,y2,z2 = baza[1][1], baza[1][2], baza[1][3]
	else
		x2,y2,z2 = cele[1][prevpunkt][1],  cele[1][prevpunkt][2], cele[1][prevpunkt][3]
	end
	local dist = getDistanceBetweenPoints3D(x1,y1,z1, x2,y2,z2)
	local wyn = math.floor(((dist/2)/25)*hajs)
	destroyPunkt()
	setElementData(localPlayer, "user:jobmoney", getElementData(localPlayer, "user:jobmoney")+wyn)
	exports.rpg_noti:createNotification("info", "Dostarczyłeś paczkę! Zarabiasz $"..wyn..". Pieniądze możesz odebrać u pracodawcy.")
	losujPunkt()
end

setElementData(localPlayer, "job:veh", false)

fileDelete("kurier_client.lua")