--[[
	Funkcje związane z graczami
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
addEvent("pokePlayer", true)
addEventHandler("pokePlayer", getRootElement(), function (plr)
	setWindowFlashing(true)
end)

fileDelete("players_client.lua")