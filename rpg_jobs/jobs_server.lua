--[[
	Uniwersalny kod prac
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
addEvent("onPlayerStartJob", true)
addEvent("onPlayerResign", true)
addEvent("onPlayerPayday", true)

function resign(plr, cmd)
	playerResign(plr)
end
addCommandHandler("resign", resign)
addCommandHandler("zwolnijsie", resign)
addCommandHandler("opuscprace", resign)

function playerResign(plr, window)
	if window then
		triggerClientEvent(plr, "destroyJobsWindow", plr)
	end
	local job = getElementData(plr, "user:job")
	if isPedInVehicle(plr) then
		exports.rpg_noti:createNotification(plr, "error", "Najpierw musisz opuścić swój pojazd!")
		return
	end
	if not job or job == 0 then
		exports.rpg_noti:createNotification(plr, "error", "Nie możesz się zwolnić, kiedy nigdzie nie pracujesz")
		return
	end
	triggerEvent("onPlayerResign", getRootElement(), plr, job)
	triggerClientEvent(plr, "onPlayerResign", plr, job)
	setElementData(plr, "user:job", false)
	setElementData(plr, "user:jobmoney", 0)
	exports.rpg_noti:createNotification(plr, "info", "Rezygnujesz ze swojej pracy")
end
addEvent("playerResign", true)
addEventHandler("playerResign", getRootElement(), playerResign)