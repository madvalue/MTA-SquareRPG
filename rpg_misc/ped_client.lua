--[[
	Reszta
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
function cancelPedDamage (attacker)
	cancelEvent()
end
addEventHandler("onClientPedDamage", getRootElement(), cancelPedDamage)

fileDelete("ped_client.lua")