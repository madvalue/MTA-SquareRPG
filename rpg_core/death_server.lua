--[[
	System śmierci
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
addEventHandler("onPlayerWasted", getRootElement(), function ()
	local player = source
	fadeCamera(player, false, 3)
	setTimer(function ()
		local skin = getElementModel(player)
		spawnPlayer(player, -2655.76953125, 699.4384765625, 27.924325942993, 0, skin, 0, 0)
		fadeCamera(player, true, 3)
		outputChatBox("W wyniku poważnych orażeń zostajesz przetransportowany/a do szpitala", player, 255, 200, 0)
	end, 4000, 1)
end)