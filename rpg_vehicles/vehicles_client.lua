--[[
	System pojazdów oparty o MySQL
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local x1,y1,z1

addEventHandler("onClientPreRender", getRootElement(), function ()
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then
		local seat = getPedOccupiedVehicleSeat(localPlayer)
		if seat == 0 then
			if not x1 or not y1 or not z1 then 
				x1,y1,z1 = getElementPosition(veh)
			end
			local x2,y2,z2 = getElementPosition(veh)
			local dist = getDistanceBetweenPoints3D(x1,y1,z1, x2,y2,z2)
			outputChatBox("t")
			if dist > 10 then
				local distance = getElementData(veh, "veh:distance")
				if distance then
					setElementData(veh, "veh:distance", distance+0.1)
					x1,y1,z1 = getElementPosition(veh)
				end
			end
		end
	end
end)

fileDelete("vehicles_client.lua")