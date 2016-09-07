--[[
	Ciucholandy
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local markers = {
	{206.7060546875, -5.322265625, 1001.2109375, 5, 1},
}
addEventHandler("onResourceStart", resourceRoot, function ()
	for i,v in ipairs(markers) do
		local marker = createMarker(v[1], v[2], v[3]-1, "cylinder", 2, 255, 200, 0, 150)
		local cs = createColSphere(v[1], v[2], v[3], 1.5)
		
		setElementInterior(marker, v[4])
		setElementDimension(marker, v[5])
		setElementInterior(cs, v[4])
		setElementDimension(cs, v[5])
		
		addEventHandler("onColShapeHit", cs, hitCiucholand)
		addEventHandler("onColShapeLeave", cs, leaveCiucholand)
	end
end)

function hitCiucholand(hit, dim)
	if getElementType(hit) ~= "player" then return end
	triggerClientEvent(hit, "createCiucholandWindow", hit)
end

function leaveCiucholand(hit, dim)
	if getElementType(hit) ~= "player" then return end
	triggerClientEvent(hit, "destroyCiucholandWindow", hit)
end

addEvent("savePlayerSkin", true)
addEventHandler("savePlayerSkin", getRootElement(), function (skin)
	setElementData(source, "user:skin", skin)
	setElementModel(source, skin)
end)