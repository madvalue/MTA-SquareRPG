--[[
	Komendy administratora
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
addCommandHandler("devmode", function (cmd)
	if not getElementData(localPlayer, "user:aduty") then return end
	if not doesHaveAdminPerms(localPlayer, "devmode") then return end
	setDevelopmentMode(true)
end)

fileDelete("commands_client.lua")