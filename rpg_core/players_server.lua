--[[
	Funkcje związane z graczami
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
addCommandHandler("togglehud", function (plr, cmd)
	if not getElementData(plr, "user:logged") then return end
	local hud = getElementData(plr, "hud:enabled")
	setElementData(plr, "hud:enabled", not hud)
end)

addCommandHandler("poke", function (plr, cmd, target)
	if not target then
		outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [ID/Nazwa gracza]", plr, 255, 255, 255, true)
		return
	end
	local player = findPlayer(plr, target)
	if not player then return end
	triggerClientEvent(player, "pokePlayer", player)
end)

function findPlayer(player, name)
	local count = 0
	local kto
	if tonumber(name) then -- nazwa to id
		for i,v in ipairs(getElementsByType("player")) do
			if getElementData(v, "user:tempid") == tonumber(name) then
				return v
			end
		end
		outputChatBox("Nie znaleziono takiego gracza", player)
		return false
	else
		for i,v in ipairs(getElementsByType("player")) do
			if string.find(getElementData(v, "user:username"), name) then
				count = count + 1
				kto = v
			end
		end
		if count > 1 then
			outputChatBox("Znaleziono więcej niż jednego gracza", player)
			return false
		elseif count < 1 then
			outputChatBox("Nie znaleziono takiego gracza", player)
			return false
		else
			return kto
		end
	end
end