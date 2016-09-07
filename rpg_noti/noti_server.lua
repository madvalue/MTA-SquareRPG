--[[
	System powiadomień
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
function createNotification(player, type, text)
	triggerClientEvent(player, "createNotification", player, type, text)
end