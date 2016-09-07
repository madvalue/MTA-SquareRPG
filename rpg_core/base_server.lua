--[[
	Podstawa
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
addEventHandler("onResourceStart", resourceRoot, function ()
	setGameType("RPG + Prace")
	setRuleValue("gamemode", "SquareRPG")
	setRuleValue("author", "value")
	
	local t = getRealTime()
	setTime(t.hour, t.minute)
	setMinuteDuration(60000)
end)

addEventHandler("onPlayerConnect", getRootElement(), function (nick, ip, username, serial)
	local q = exports.rpg_mysql:mysql_query("SELECT * FROM rpg_serials WHERE serial=?", serial)
	if #q < 1 then
		cancelEvent(true, "Nie jesteś zautoryzowany do wejścia na ten serwer") 
	end
	
	local q2 = exports.rpg_mysql:mysql_query("SELECT * FROM rpg_bany WHERE serial=? AND enddate>NOW()", serial)
	if #q2 > 0 then
		cancelEvent(true, "Twój numer seryjny został zbanowany ("..q2[1].reason..")")
	end
end)

addEventHandler("onPlayerChangeNick", getRootElement(), function ()
	cancelEvent()
end)