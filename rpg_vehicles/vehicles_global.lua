--[[
	System pojazdów oparty o MySQL
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local custom_vehicles = { -- Do rozwinięcia
	[604] = {name="MFK"},
}

function getVehicleCustomName(model)
	local name = ""
	if custom_vehicles[model] then
		name = custom_vehicles[model].name
	else
		name = getVehicleNameFromModel(model)
	end
	return name
end