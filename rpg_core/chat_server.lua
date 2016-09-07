--[[
	Chat serwerowy
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local bad_words = {"kurwa", "chuj", "japierdole", "pierdole", "chuju", "jebana", "jebać", "jebie", "jebałem", "jebałam", "jebłem", "jebłam", "pojeb", "kurwiszon", "kurwica", "skurwysyn", "kurewsko", "nakurwiam", "wykurwiam", "wkurwiam", "jebaj", "pizde", "pizda", "rozkurwia", "rozkurwi", "rozkurwiam", "rozkurwiamy", "rozkurwiają", "rozkurwiajom", "napierdala", "spierdalaj", "spierdalam", "spierdalamy", "spierdalajcie", "sprierdalają", "kurwo"}
local emoty = {
	[":d"] = "uśmiecha się szeroko."
}

function pm(plr, cmd, kto, ...)
	if not getElementData(plr, "user:logged") then return end
	if getElementData(plr, "pm:off") then
		exports.rpg_noti:createNotification(plr, "error", "Nie możesz wysyłać wiadomości, kiedy masz je wyłączone")
		return
	end
	if not kto or not ... then
		outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [ID/Nazwa gracza] [Treść]", plr, 255, 255, 255, true)
		return
	end
	local target = findPlayer(plr, kto)
	if not target then return end
	local tresc = table.concat({...}, " ")
	local target_id = getElementData(target, "user:tempid")
	local target_name = getElementData(target, "user:username")
	local player_id = getElementData(plr, "user:tempid")
	local player_name = getElementData(plr, "user:username")
	outputChatBox("PM >> ["..target_id.."] "..target_name..": "..tresc, plr, 255, 200, 0)
	outputChatBox("PM << ["..player_id.."] "..player_name..": "..tresc, target, 255, 200, 0)
	exports.rpg_admin:addToEcho("[PM] "..player_name.."/"..player_id.. " > "..target_name.."/"..target_id..": "..tresc)
	setElementData(target, "pm:re", plr)
end
addCommandHandler("pm", pm)

function re(plr, cmd, ...)
	if not getElementData(plr, "user:logged") then return end
	if not getElementData(plr, "pm:re") then return end
	if not ... then
		outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [Treść]", plr, 255, 255, 255, true)
		return
	end
	local target = getElementData(plr, "pm:re")
	local player_id = getElementData(plr, "user:tempid")
	local player_name = getElementData(plr, "user:username")
	local target_id = getElementData(target, "user:tempid")
	local target_name = getElementData(target, "user:username")
	if not target_name then
		exports.rpg_noti:createNotification(plr, "error", "Nie znaleziono takiego gracza")
		return
	end
	local tresc = table.concat({...}, " ")
	outputChatBox("PM >> ["..target_id.."] "..target_name..": "..tresc, plr, 255, 200, 0)
	outputChatBox("PM << ["..player_id.."] "..player_name..": "..tresc, target, 255, 200, 0)
	exports.rpg_admin:addToEcho("[PM] "..player_name.."/"..player_id.. " > "..target_name.."/"..target_id..": "..tresc)
	setElementData(target, "pm:re", plr)
end
addCommandHandler("re", re)

function admins(plr, cmd)
	if not getElementData(plr, "user:logged") then return end
	local text1 = ""
	local count1 = 0
	local text2 = ""
	local count2 = 0
	for i,v in ipairs(getElementsByType("player")) do
		if getElementData(v, "user:admin") == 1 then
			if getElementData(v, "user:aduty") then
				if count1 == 0 then
					text1 = getElementData(v, "user:username").. " ["..getElementData(v, "user:tempid").."]"
				else
					text1 = text1..", "..getElementData(v, "user:username").. " ["..getElementData(v, "user:tempid").."]"
				end
				count1 = count1 + 1
			end
		elseif getElementData(v, "user:admin") == 2 then
			if getElementData(v, "user:aduty") then
				if count2 == 0 then
					text2 = getElementData(v, "user:username").. " ["..getElementData(v, "user:tempid").."]"
				else
					text2 = text2..", "..getElementData(v, "user:username").. " ["..getElementData(v, "user:tempid").."]"
				end
				count2 = count2 + 1
			end
		end
	end
	if count1 > 0 then
		outputChatBox("Administracja:", plr, 255, 0, 0)
		outputChatBox(text1, plr, 230, 230, 230)
	end
	if count2 > 0 then
		outputChatBox("Support:", plr, 0, 180, 247)
		outputChatBox(text2, plr, 230, 230, 230)
	end
	
	if count1 < 1 and count2 < 1 then
		exports.rpg_noti:createNotification(plr, "info", "Brak aktywnych członków ekipy")
	end
end
addCommandHandler("admins", admins)

function zaplac(plr, cmd, target, ile)
	if not getElementData(plr, "user:logged") then return end
	if not target or not ile then
		outputChatBox("#ffc800Użyj: #eeeeee/"..cmd.." [ID/Nazwa gracza] [Kwota]", plr, 255, 255, 255, true)
		return
	end
	local player = findPlayer(plr, target)
	if not player then return end
	local ile = tonumber(ile)
	if not ile then
		exports.rpg_noti:createNotification(plr, "error", "Wpisana wartosć musi być liczbą")
		return
	end
	local ile = math.floor(ile)
	if ile < 1 then
		exports.rpg_noti:createNotification(plr, "error", "Wpisana wartosć musi być większa od 0")
		return
	end
	local money1 = getElementData(plr, "user:money")
	local money2 = getElementData(player, "user:money")
	if money1 < ile then
		exports.rpg_noti:createNotification(plr, "error", "Nie posiadasz przy sobie takiej sumy")
		return
	end
	setElementData(player, "user:money", getElementData(player, "user:money")+ile)
	setElementData(plr, "user:money", getElementData(plr, "user:money")-ile)
	
	outputChatBox("#ffc800Przekazujesz graczowi #eeeeee"..getElementData(player, "user:username").."#ffc800 kwotę #eeeeee$"..ile, plr, 255, 255, 255, true)
	outputChatBox("#ffc800Otrzymujesz od gracza #eeeeee"..getElementData(plr, "user:username").."#ffc800 kwotę #eeeeee$"..ile, player, 255, 255, 255, true)
	
	local player_id = getElementData(plr, "user:tempid")
	local player_name = getElementData(plr, "user:username")
	local target_id = getElementData(player, "user:tempid")
	local target_name = getElementData(player, "user:username")
	exports.rpg_admin:addToEcho("[PRZELEW] "..player_name.."/"..player_id.. " > "..target_name.."/"..target_id..": $"..ile)
end
addCommandHandler("przelej", zaplac)
addCommandHandler("zaplac", zaplac)

function findBadWords(player, msg)
	local count = 0
	for i,v in ipairs(bad_words) do
		if string.find(msg:lower(), v) then
			local c = ""
			for i=1,v:len() do
				c = c.."*"
			end
			local k1,k2 = string.find(msg:lower(), v)
			--msg = string.gsub(msg:lower(), v, c)
			msg = string.gsub(msg, string.sub(msg, k1, k2), c)
			count = count + 1
		end
	end
	if count > 0 then
		outputChatBox("Wyrażenia wulgarne są na tym serwerze zabronione", player, 255, 0, 0)
	end
	return msg
end

function findEmoticons(player, msg)
	return msg
end

addEventHandler("onPlayerChat", getRootElement(), function (msg, type)
	cancelEvent()
	if not getElementData(source, "user:logged") then return end
	if type == 0 then
		local x,y,z = getElementPosition(source)
		local chat_cs = createColSphere(x, y, z, 25)
		local name = getElementData(source, "user:username")
		local id = getElementData(source, "user:tempid")
		local msg = string.gsub(msg, "#%x%x%x%x%x%x", "")
		--msg = findEmoticons(source, msg)
	--	msg = findBadWords(source, msg)
		
		for i,v in ipairs(getElementsWithinColShape(chat_cs, "player")) do
			if getElementInterior(v) == getElementInterior(source) and getElementDimension(v) == getElementDimension(source) then
				outputChatBox("#888888"..id.." #ffffff"..name.." mówi: #eeeeee"..msg, v, 230, 230, 230, true)
			end
		end
		
		exports.rpg_admin:addToEcho("[IC] "..name.."/"..id..": "..msg)
		
		destroyElement(chat_cs)
	elseif type == 1 then
		local x,y,z = getElementPosition(source)
		local cs = createColSphere(x, y, z, 25)
		local name = getElementData(source, "user:username")
		local id = getElementData(source, "user:tempid")
		local msg = string.gsub(msg, "#%x%x%x%x%x%x", "")
		
		for i,v in ipairs(getElementsWithinColShape(cs)) do
			if getElementInterior(v) == getElementInterior(source) and getElementDimension(v) == getElementDimension(source) then
				outputChatBox("* "..name.." "..msg, v, 142, 142, 255, true)
			end
		end
		
		destroyElement(cs)
	end
end)

function cmd_do(plr, cmd, ...)
	local text = table.concat({...}, " ")
	if text:len() < 1 then return end
		local x,y,z = getElementPosition(plr)
		local cs = createColSphere(x, y, z, 25)
		local name = getElementData(plr, "user:username")
		local id = getElementData(plr, "user:tempid")
		local text = string.gsub(text, "#%x%x%x%x%x%x", "")
		
		for i,v in ipairs(getElementsWithinColShape(cs)) do
			if getElementInterior(v) == getElementInterior(plr) and getElementDimension(v) == getElementDimension(plr) then
				outputChatBox("* "..text.." (( "..name.." ))", v, 61, 112, 255, true)
			end
		end
		
		destroyElement(cs)
end
addCommandHandler("do", cmd_do)