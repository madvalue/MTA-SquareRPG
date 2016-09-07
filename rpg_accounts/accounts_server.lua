--[[
	System kont graczy w oparciu o MySQL
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
addEvent("onPlayerAccountLogin", true)
local defpos = "-1952.56250, 137.83763, 26.28125, 0, 0, 0" -- Domyślna pozycja musi być w stringu!

function auth(username, password)
	if not username then
		exports.rpg_noti:createNotification(source, "error", "Błąd podczas próby logowania, zgłoś to administratorowi na forum [ERR01]")
		return
	end
	if not password then
		exports.rpg_noti:createNotification(source, "error", "Błąd podczas próby logowania, zgłoś to administratorowi na forum [ERR02]")
		return
	end
	local q = exports.rpg_mysql:mysql_query("SELECT * FROM rpg_accounts WHERE username=? AND password=?", username, md5(password))
	if #q > 1 then -- Znaleziono więcej niż 1 usera o podanej kombinacji loginu i hasła
		exports.rpg_noti:createNotification(source, "error", "Błąd podczas próby logowania, zgłoś to administratorowi na forum [ERR03]")
	elseif #q < 1 then -- Nie znaleziono żadnego usera o podanej kombinacji loginu i hasła
		exports.rpg_noti:createNotification(source, "error", "Podana kombinacja nazwy użytkownika i hasła jest błędna")
	else -- Jest tylko jeden user! Hura!
		local player = source
		fadeCamera(player, false)
		setPlayerName(player, q[1].username)
	
		setElementData(player, "user:uid", q[1].uid)
		setElementData(player, "user:username", q[1].username)
		setElementData(player, "user:email", q[1].email)
		setElementData(player, "user:regdate", q[1].regdate)
		setElementData(player, "user:lastlogin", q[1].lastlogin)
		setElementData(player, "user:serial", q[1].serial)
		setElementData(player, "user:ip", q[1].ip)
		setElementData(player, "user:skin", q[1].skin)
		setElementData(player, "user:money", q[1].money)
		setElementData(player, "user:bankmoney", q[1].bankmoney)
		setElementData(player, "user:gamescore", q[1].gamescore)
		setElementData(player, "user:job", q[1].job)
		setElementData(player, "user:jobmoney", q[1].jobmoney)
		setElementData(player, "user:pjA", q[1].pjA)
		setElementData(player, "user:pjB", q[1].pjB)
		setElementData(player, "user:pjC", q[1].pjC)
		setElementData(player, "user:onlinetime", q[1].onlinetime)
		setElementData(player, "user:aduty", false)
		
		if string.len(q[1].serial) < 1 then
			local serial = getPlayerSerial(player)
			local q2 = exports.rpg_mysql:mysql_query("UPDATE rpg_accounts SET serial=? WHERE uid=?", serial, q[1].uid)
			if not q2 then
				exports.rpg_noti:createNotification(source, "error", "Błąd podczas próby logowania, zgłoś to administratorowi na forum [ERR10]")
				return
			end
		end
		
		if string.len(q[1].ip) < 1 then
			local ip = getPlayerIP(player)
			local q3 = exports.rpg_mysql:mysql_query("UPDATE rpg_accounts SET ip=? WHERE uid=?", ip, q[1].uid)
			if not q3 then
				exports.rpg_noti:createNotification(source, "error", "Błąd podczas próby logowania, zgłoś to administratorowi na forum [ERR11]")
				return
			end
		end
		
		local q2 = exports.rpg_mysql:mysql_query("SELECT * FROM rpg_admins WHERE user=?", q[1].uid)
		if #q2 > 0 then
			setElementData(player, "user:admin", q2[1].level)
			setElementData(player, "user:aperm", q2[1])
		else
			setElementData(player, "user:admin", 0)
			setElementData(player, "user:aperm", false)
		end
		
		local pd = split(q[1].premium, " ")
		local pd1 = split(pd[1], "-")
		local pd2 = split(pd[2], ":")
		local ts1 = getTimestamp()
		local ts2 = getTimestamp(pd1[1], pd1[2], pd1[3], pd2[1], pd2[2], pd2[3])
		if ts1 <= ts2 then
			local fs = ts2 - ts1
			local p_left = math.floor(fs/86400)
			if p_left < 1 then
				p_left = math.floor(fs/3600)
				if p_left < 1 then
					p_left = math.floor(fs/60).."m"
				else
					p_left = p_left.."h"
				end
			else
					p_left = p_left.."d"
			end
			outputChatBox("Posiadasz aktywne konto premium jeszcze przez około "..p_left, player, 255, 200, 0)
			setElementData(player, "user:premium", true)
			setElementData(player, "user:premium:ts", ts2)
		else
			setElementData(player, "user:premium", false)
		end
		
		triggerClientEvent(player, "onPlayerAccountLogin", player)
		triggerEvent("onPlayerAccountLogin", getRootElement(), player)
		
		local timer = setTimer(function ()
			setElementData(player, "user:onlinetime", getElementData(player, "user:onlinetime")+1)
			local cts = getTimestamp()
			if getElementData(player, "user:premium") then
				local pts = getElementData(player, "user:premium:ts")
				if pts < cts then
					outputChatBox("Twoje konto premium właśnie wygasło", player, 255, 200, 0)
					setElementData(player, "user:premium", false)
				end
			end
		end, 1000, 0)
		setElementData(player, "user:timer", timer)
		
		setTimer(function ()
			fadeCamera(player, true)
			local pos = split(q[1].position, ",")
			spawnPlayer(player, pos[1], pos[2], pos[3], pos[4], q[1].skin, pos[5], pos[6])
			
			setElementHealth(player, q[1].health)
			setPedArmor(player, q[1].armor)
			
			toggleControl(player, "fire", false)
			setCameraTarget(player, player)
			setElementData(player, "user:logged", true)
			if tonumber(pos[5]) < 1 then
				showPlayerHudComponent(player, "radar", true)
			end
			setElementData(player, "hud:enabled", true)
			showChat(player, true)
		end, 2000, 1)
		
		
		triggerClientEvent(player, "destroyLogin", player)
	end
end
addEvent("auth", true)
addEventHandler("auth", getRootElement(), auth)

function register(username, password, email)
	if not username then
		exports.rpg_noti:createNotification(source, "error", "Błąd podczas próby rejestracji, zgłoś to administratorowi na forum [ERR04]")
		return
	end
	if not password then
		exports.rpg_noti:createNotification(source, "error", "Błąd podczas próby rejestracji, zgłoś to administratorowi na forum [ERR05]")
		return
	end
	if not email then
		exports.rpg_noti:createNotification(source, "error", "Błąd podczas próby rejestracji, zgłoś to administratorowi na forum [ERR06]")
		return
	end
	local q1 = exports.rpg_mysql:mysql_query("SELECT username FROM rpg_accounts WHERE username=?", username)
	if not q1 then
		exports.rpg_noti:createNotification(source, "error", "Błąd podczas próby rejestracji, zgłoś to administratorowi na forum [ERR09]")
		return
	elseif #q1 > 0 then
		exports.rpg_noti:createNotification(source, "error", "Podana nazwa użytkownika jest już w użytku")
		return
	end
	local q2 = exports.rpg_mysql:mysql_query("SELECT email FROM rpg_accounts WHERE email=?", email)
	if not q2 then
		exports.rpg_noti:createNotification(source, "error", "Błąd podczas próby rejestracji, zgłoś to administratorowi na forum [ERR08]")
		return
	elseif #q2 > 0 then
		exports.rpg_noti:createNotification(source, "error", "Podany adres E-Mail jest już w użyciu")
		return
	end
	local ip = getPlayerIP(source)
	local serial = getPlayerSerial(source)
	local q3 = exports.rpg_mysql:mysql_query("INSERT INTO rpg_accounts SET username=?, password=?, email=?, serial=?, ip=?, position=?", username, md5(password), email, serial, ip, defpos)
	if q3 then
		triggerClientEvent(source, "switchLogin", source)
		exports.rpg_noti:createNotification(source, "info", "Twoje konto zostało utworzone, możesz się teraz zalogować!")
	else
		exports.rpg_noti:createNotification(source, "error", "Błąd podczas próby rejestracji, zgłoś to administratorowi na forum [ERR07]")
	end
end
addEvent("register", true)
addEventHandler("register", getRootElement(), register)

addEventHandler("onPlayerQuit", getRootElement(), function ()
	local uid = getElementData(source, "user:uid")
	if not uid then return end
	local money = getElementData(source, "user:money")
	local bankmoney = getElementData(source, "user:bankmoney")
	local gamescore = getElementData(source, "user:gamescore")
	local skin = getElementData(source, "user:skin")
	local x,y,z = getElementPosition(source)
	local _,_,rz = getElementRotation(source)
	local int = getElementInterior(source)
	local dim = getElementDimension(source)
	local health = getElementHealth(source)
	local armor = getPedArmor(source)
	local pos = x..", "..y..", "..z..", "..rz..", "..int..", "..dim
	local job = getElementData(source, "user:job") or 0
	local jobmoney = getElementData(source, "user:jobmoney") or 0
	local onlinetime = getElementData(source, "user:onlinetime")
	local timer = getElementData(source, "user:timer")
	killTimer(timer)
	local q = exports.rpg_mysql:mysql_query("UPDATE rpg_accounts SET money=?, bankmoney=?, gamescore=?, skin=?, position=?, health=?, armor=?, job=?, jobmoney=?, onlinetime=? WHERE uid=?", money, bankmoney, gamescore, skin, pos, health, armor, job, jobmoney, onlinetime, uid)
	if not q then
		outputDebugString("[rpg_accounts] Wystąpił problem z zapisywaniem gracza o UID "..uid)
	end
end)


----------------
---- UTILS ----
----------------
function getKoncowka(time, k1, k2, k3)
	if time == 0 then
		return k1
	elseif time == 1 then
		return k2
	else
		return k3
	end
end

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