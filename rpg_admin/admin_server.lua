--[[
	System administratorów
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
function addToEcho(text)
	triggerClientEvent("addToEcho", getRootElement(), text)
end


function doesHaveAdminPerms(player, perm)
	local t = getElementData(player, "user:aperm")
	if not t then return false end
	if tonumber(t[perm]) > 0 then
		return true
	else
		return false
	end
end