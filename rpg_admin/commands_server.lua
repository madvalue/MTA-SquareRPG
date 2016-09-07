--[[
	Komendy administratora
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
addCommandHandler("gp", function (plr, cmd)
	local x,y,z = getElementPosition(plr)
	local _,_,rz = getElementRotation(plr)
	local int = getElementInterior(plr)
	local dim = getElementDimension(plr)
	outputChatBox(x..", "..y..", "..z..", "..rz, plr)
	outputChatBox("int: "..int.." dim: "..dim, plr)
end)

function cmd_pwarn(plr, cmd, target, ...)
	if not getElementData(plr, "user:aduty") then return end
	if not doesHaveAdminPerms(plr, "pkary") then return end
	if not target or not ... then
		outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [ID/Nazwa gracza] [Powód]", plr, 255, 255, 255, true)
		return
	end
	local player = findPlayer(plr, target)
	local text = table.concat({...}, " ")
	if player then
		--outputChatBox("Gracz "..getElementData(player, "user:username").." otrzymał ostrzeżenie od "..getElementData(plr, "user:username").."!", getRootElement(), 255, 0, 0)
		--outputChatBox("Powód: "..text, getRootElement(), 255, 0, 0)
		triggerClientEvent(getRootElement(), "createAnn", getRootElement(), "Gracz "..getElementData(player, "user:username").." otrzmuje ostrzeżenie od "..getElementData(plr, "user:username"), text)
		triggerClientEvent(player, "createWarn", player, text)
		
		outputChatBox(" ", player)
		outputChatBox("### Otrzymałeś/aś ostrzeżenie! ###", player, 255, 0, 0)
		outputChatBox(text, player, 230, 230, 230)
		outputChatBox(" ", player)
	end
end
addCommandHandler("pwarn", cmd_pwarn)

function cmd_pkick(plr, cmd, target, ...)
	if not getElementData(plr, "user:aduty") then return end
	if not doesHaveAdminPerms(plr, "pkary") then return end
	if not target or not ... then
		outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [ID/Nazwa gracza] [Powód]", plr, 255, 255, 255, true)
		return
	end
	local player = findPlayer(plr, target)
	local text = table.concat({...}, " ")
	if player then
		--outputChatBox("Gracz "..getElementData(player, "user:username").." otrzymał ostrzeżenie od "..getElementData(plr, "user:username").."!", getRootElement(), 255, 0, 0)
		--outputChatBox("Powód: "..text, getRootElement(), 255, 0, 0)
		triggerClientEvent(getRootElement(), "createAnn", getRootElement(), "Gracz "..getElementData(player, "user:username").." zostaje wykopany/a przez "..getElementData(plr, "user:username"), text)
		outputConsole("===== ZOSTAŁEŚ/AŚ WYKOPANY/A =====", player)
		outputConsole("Nadawca: "..getElementData(plr, "user:username"), player)
		outputConsole("Powód: "..text, player)
		outputConsole(" ", player)
		kickPlayer(player, getElementData(plr, "user:username"), "Sprawdź swoją konsolę (~)")
	end
end
addCommandHandler("pkick", cmd_pkick)

function cmd_pban(plr, cmd, target, t1, t2, ...)
	if not getElementData(plr, "user:aduty") then return end
	if not doesHaveAdminPerms(plr, "pkary") then return end
	if not target or not t1 or not t2 or not ... then
		outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [ID/Nazwa gracza] [Jednostka m/h/d] [Czas] [Powód]", plr, 255, 255, 255, true)
		return
	end
	local player = findPlayer(plr, target)
	if not player then return end
		local text = table.concat({...}, ", ")
		local ts_start = getTimestamp()
		if t1 == "m" then
			local t2 = tonumber(t2)
			local ts_final = ts_start + t2*60
			local time = getRealTime(ts_final)
			triggerClientEvent(getRootElement(), "createAnn", getRootElement(), "Gracz "..getElementData(player, "user:username").." zostaje zbanowany/a przez "..getElementData(plr, "user:username").." ("..t2.."m)", text)
			local user_id = getElementData(player, "user:uid")
			local user_serial = getPlayerSerial(player)
			local admin_id = getElementData(plr, "user:uid")
			local final_date = (time.year+1900).."-"..(time.month+1).."-"..(time.monthday).." "..(time.hour)..":"..(time.minute)..":"..(time.second)
			exports.rpg_mysql:mysql_query("INSERT INTO rpg_bany SET userid=?, serial=?, admin=?, reason=?, enddate=?", user_id, user_serial, admin_id, text, final_date)
			outputConsole("~~~~ ZOSTAŁEŚ/AŚ ZBANOWANY/A ~~~~", player)
			outputConsole("Czas: "..t2.."m", player)
			outputConsole("Nadawca: "..getElementData(plr, "user:username"), player)
			outputConsole("Powód: "..text, player)
			kickPlayer(player, getElementData(plr, "user:username"), "Otwórz konsolę (~)")
		elseif t1 == "h" then
			local t2 = tonumber(t2)
			local ts_final = ts_start + t2*3600
			local time = getRealTime(ts_final)
			triggerClientEvent(getRootElement(), "createAnn", getRootElement(), "Gracz "..getElementData(player, "user:username").." zostaje zbanowany/a przez "..getElementData(plr, "user:username").." ("..t2.."h)", text)
			local user_id = getElementData(player, "user:uid")
			local user_serial = getPlayerSerial(player)
			local admin_id = getElementData(plr, "user:uid")
			local final_date = (time.year+1900).."-"..(time.month+1).."-"..(time.monthday).." "..(time.hour)..":"..(time.minute)..":"..(time.second)
			exports.rpg_mysql:mysql_query("INSERT INTO rpg_bany SET userid=?, serial=?, admin=?, reason=?, enddate=?", user_id, user_serial, admin_id, text, final_date)
			outputConsole("~~~~ ZOSTAŁEŚ/AŚ ZBANOWANY/A ~~~~", player)
			outputConsole("Czas: "..t2.."m", player)
			outputConsole("Nadawca: "..getElementData(plr, "user:username"), player)
			outputConsole("Powód: "..text, player)
			kickPlayer(player, getElementData(plr, "user:username"), "Otwórz konsolę (~)")
		elseif t1 == "d" then
			local t2 = tonumber(t2)
			local ts_final = ts_start + t2*86400
			local time = getRealTime(ts_final)
			triggerClientEvent(getRootElement(), "createAnn", getRootElement(), "Gracz "..getElementData(player, "user:username").." zostaje zbanowany/a przez "..getElementData(plr, "user:username").." ("..t2.."d)", text)
			local user_id = getElementData(player, "user:uid")
			local user_serial = getPlayerSerial(player)
			local admin_id = getElementData(plr, "user:uid")
			local final_date = (time.year+1900).."-"..(time.month+1).."-"..(time.monthday).." "..(time.hour)..":"..(time.minute)..":"..(time.second)
			exports.rpg_mysql:mysql_query("INSERT INTO rpg_bany SET userid=?, serial=?, admin=?, reason=?, enddate=?", user_id, user_serial, admin_id, text, final_date)
			outputConsole("~~~~ ZOSTAŁEŚ/AŚ ZBANOWANY/A ~~~~", player)
			outputConsole("Czas: "..t2.."m", player)
			outputConsole("Nadawca: "..getElementData(plr, "user:username"), player)
			outputConsole("Powód: "..text, player)
			kickPlayer(player, getElementData(plr, "user:username"), "Otwórz konsolę (~)")
		else
			outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [ID/Nazwa gracza] [Jednostka m/h/d] [Czas] [Powód]", plr, 255, 255, 255, true)
		end
end
addCommandHandler("pban", cmd_pban)

function cmd_aclreload(plr, cmd)
	if not getElementData(plr, "user:aduty") then return end
	if not doesHaveAdminPerms(plr, "res") then return end
	aclReload()
	outputChatBox("Plik ACL został przeładowany", plr, 255, 200, 0)
end
addCommandHandler("areload", cmd_aclreload)

function cmd_givemoney(plr, cmd, target, ile)
	if not getElementData(plr, "user:aduty") then return end
	if not doesHaveAdminPerms(plr, "pmoney") then return end
	if not target or not ile then
		outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [ID/Nazwa gracza] [Kwota]", plr, 255, 255, 255, true)
		return
	end
	if not tonumber(ile) then
		outputChatBox("Wpisana wartość musi być liczbą!", plr, 255, 0, 0)
		return
	end
	local player = findPlayer(plr, target)
	if player then
		local money = getElementData(player, "user:money")
		setElementData(player, "user:money", money+tonumber(ile))
	end
end
addCommandHandler("givemoney", cmd_givemoney)

function cmd_aduty(plr, cmd)
	if getElementData(plr, "user:admin") < 1 then return end
	local duty = getElementData(plr, "user:aduty")
	setElementData(plr, "user:aduty", not duty)
	outputChatBox("#ffc800aduty: #eeeeee"..tostring(not duty), plr, 255, 255, 255, true)
	if duty then
		setElementData(plr, "user:aecho", false)
	end
end
addCommandHandler("aduty", cmd_aduty)

function cmd_echo(plr, cmd)
	if not getElementData(plr, "user:aduty") then return end
	if not doesHaveAdminPerms(plr, "echo") then return end
	local echo = getElementData(plr, "user:aecho")
	setElementData(plr, "user:aecho", not echo)
	outputChatBox("#ffc800echo: #eeeeee"..tostring(not echo), plr, 255, 255, 255, true)
end
addCommandHandler("echo", cmd_echo)

function cmd_inv(plr, cmd)
	if not getElementData(plr, "user:aduty") then return end
	if tonumber(getElementData(plr, "user:admin")) < 1 then return end
	local a = getElementAlpha(plr)
	if a == 255 then
		setElementAlpha(plr, 0)
	else
		setElementAlpha(plr, 255)
	end
end
addCommandHandler("inv", cmd_inv)

function cmd_freeze(plr, cmd, target)
	if not getElementData(plr, "user:aduty") then return end
	if not doesHaveAdminPerms(plr, "pkary") then return end
	if not target then
		outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [ID/Nazwa gracza]", plr, 255, 255, 255, true)
		return
	end
	local player = findPlayer(plr, target)
	if not player then return end
	local freeze = getElementData(player, "admin:freeze")
	if freeze then
		setElementFrozen(player, false)
		setElementData(player, "admin:freeze", false)
		outputChatBox("Zostałeś/aś odmrożony przez administratora", player, 255, 0, 0)
		outputChatBox(getElementData(player, "user:username").." został/a odmrożony", plr, 255, 200, 0)
	else
		setElementFrozen(player, true)
		setElementData(player, "admin:freeze", true)
		outputChatBox("Zostałeś/aś zamrożony przez administratora", player, 255, 0, 0)
		outputChatBox(getElementData(player, "user:username").." został/a zamrożony", plr, 255, 200, 0)
	end
end
addCommandHandler("afreeze", cmd_freeze)

function cmd_vfix(plr, cmd, target)
	if not getElementData(plr, "user:aduty") then return end
	if not doesHaveAdminPerms(plr, "vdata") then return end
	if not target then
		outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [ID/Nazwa gracza]", plr, 255, 255, 255, true)
		return
	end
	local player = findPlayer(plr, target)
	if not player then return end
	if not isPlayerInVehicle(player) then
		outputChatBox("Ten gracz nie jest w pojeździe", plr, 255, 0, 0)
		return
	end
	local veh = getPedOccupiedVehicle(player)
	if not veh then
		outputChatBox("Ten gracz nie jest w pojeździe", plr, 255, 0, 0)
		return
	end
	fixVehicle(veh)
end
addCommandHandler("vfix", cmd_vfix)

function cmd_vflip(plr, cmd, target)
	if not getElementData(plr, "user:aduty") then return end
	if not doesHaveAdminPerms(plr, "vdata") then return end
	if not target then
		outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [ID/Nazwa gracza]", plr, 255, 255, 255, true)
		return
	end
	local player = findPlayer(plr, target)
	if not player then return end
	if not isPlayerInVehicle(player) then
		outputChatBox("Ten gracz nie jest w pojeździe", plr, 255, 0, 0)
		return
	end
	local veh = getPedOccupiedVehicle(player)
	if not veh then
		outputChatBox("Ten gracz nie jest w pojeździe", plr, 255, 0, 0)
		return
	end
	local _,_,rz = getElementRotation(veh)
	setElementRotation(veh, 0, 0, rz)
end
addCommandHandler("vflip", cmd_vflip)

function cmd_tpto(plr, cmd, target)
	if not getElementData(plr, "user:aduty") then return end
	if not doesHaveAdminPerms(plr, "tp") then return end
	if not target then
		outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [ID/Nazwa gracza]", plr, 255, 255, 255, true)
		return
	end
	local player = findPlayer(plr, target)
	if not player then return end
	local x,y,z = getElementPosition(player)
	setElementPosition(plr, x+1, y, z)
	setElementAlpha(plr, 0)
end
addCommandHandler("tpto", cmd_tpto)

function cmd_tphr(plr, cmd, target)
	if not getElementData(plr, "user:aduty") then return end
	if not doesHaveAdminPerms(plr, "tp") then return end
	if not target then
		outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [ID/Nazwa gracza]", plr, 255, 255, 255, true)
		return
	end
	local player = findPlayer(plr, target)
	if not player then return end
	local x,y,z = getElementPosition(plr)
	setElementPosition(player, x+1, y, z)
end
addCommandHandler("tphr", cmd_tphr)


-----------------------------
---- GLOBALNE CZATY ----
-----------------------------

function cmd_ga(plr, cmd, ...)
	if not doesHaveAdminPerms(plr, "gchat") then return end
	if not ... then 
			outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [Treść]", plr, 255, 255, 255, true)
		return
	end
	local tresc = table.concat({...}, " ")
	outputChatBox("[#] "..tresc, getRootElement(), 255, 200, 0, true)
end
addCommandHandler("ga", cmd_ga)

function cmd_gb(plr, cmd, ...)
	if not doesHaveAdminPerms(plr, "gchat") then return end
	if not ... then 
			outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [Treść]", plr, 255, 255, 255, true)
		return
	end
	local tresc = table.concat({...}, " ")
	outputChatBox("[#] "..tresc, getRootElement(), 255, 0, 0, true)
end
addCommandHandler("gb", cmd_gb)

function cmd_gc(plr, cmd, ...)
	if not doesHaveAdminPerms(plr, "gchat") then return end
	if not ... then 
			outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [Treść]", plr, 255, 255, 255, true)
		return
	end
	local tresc = table.concat({...}, " ")
	outputChatBox("[#] "..tresc, getRootElement(), 0, 150, 255, true)
end
addCommandHandler("gc", cmd_gc)







----------------
---- UTILS ----
----------------
function getTimestamp(year, month, day, hour, minute, second)
    -- initiate variables
    local monthseconds = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400 }
    local timestamp = 0
    local datetime = getRealTime()
    year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
    hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second
 
    -- calculate timestamp
    for i=1970, year-1 do timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000) end
    for i=1, month-1 do timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
    timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second
 
    timestamp = timestamp - 3600 --GMT+1 compensation
    if datetime.isdst then timestamp = timestamp - 3600 end
 
    return timestamp
end

function isLeapYear(year)
    if year then year = math.floor(year)
    else year = getRealTime().year + 1900 end
    return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end

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
