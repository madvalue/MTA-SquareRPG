--[[
	Bankomaty
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local atms = {
	{-2016.2529296875, -102.2, 35.370620727539, 0}, -- Szkoła jazdy SF
	{-2765.3544921875, 372.33984375, 6.339786529541, 270}, -- Urząd SF
	{-2450.3212890625, 755.71484375, 35.171875, 180}, -- Supa save SF
	{-1684.541015625, 1346.662109375, 7.1721897125244, 45}, -- Pier 69 SF
	{-1980.6103515625, 131.0771484375, 27.6875, 90}, -- Cranbery station SF
	{-2654.1376953125, -22.478515625, 6.1328125, 180}, -- Osiedla mieszkaniowe SF
	{-2033.50390625, 454.5498046875, 35.17229461669, 0}, -- Budynek koło doherty SF
	{-1988.65625, 1125.806640625, 54.46875, 270}, -- Przy kościele SF
}

addEventHandler("onResourceStart", resourceRoot, function ()
	for i,v in ipairs(atms) do
		v.atm = createObject(2754, v[1], v[2], v[3]-0.2, 0, 0, v[4]-90)
		v.cs = createColSphere(v[1], v[2], v[3], 1)
		v.blip = createBlip(v[1], v[2], v[3], 0, 1, 0, 255, 0, 255, -1, 300)
		attachElements(v.cs, v.atm, -0.7, 0, 0)

		setElementData(v.cs, "id", i)
		setElementData(v.cs, "atm", v.atm)
		
		local t = createElement("text")
		setElementPosition(t, v[1], v[2], v[3]+1.5)
		setElementData(t, "text", "Bankomat #"..i)
		
		addEventHandler("onColShapeHit", v.cs, atmHit)
		addEventHandler("onColShapeLeave", v.cs, atmLeave)
	end
end)

function atmHit(hit)
	if getElementType(hit) ~= "player" then return end
	if isPedInVehicle(hit) then return end
	triggerClientEvent(hit, "createATMWindow", hit)
end

function atmLeave(hit)
	if getElementType(hit) ~= "player" then return end
	if isPedInVehicle(hit) then return end
	triggerClientEvent(hit, "destroyATMWindow", hit)
end