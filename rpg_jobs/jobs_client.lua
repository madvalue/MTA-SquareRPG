--[[
	Uniwersalny kod prac
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local sw,sh = guiGetScreenSize()
local browser, details
local state = "hidden"
local y = sh
local progress = 0

addEvent("onPlayerStartJob", true)
addEvent("onPlayerResign", true)
addEvent("onClientPlayerPayday", true)

addEventHandler("onClientRender", getRootElement(), function ()
	if state == "showing" then
		progress = progress + 0.04
		y,_,_ = interpolateBetween(sh, 0, 0, sh/2-175, 0, 0, progress, "Linear")
		guiSetPosition(browser, sw/2-250, y, false)
		if progress >= 1 then
			state = "showed"
		end
	elseif state == "hiding" then
		progress = progress + 0.07
		y,_,_ = interpolateBetween(sh/2-175, 0, 0, sh, 0, 0, progress, "Linear")
		guiSetPosition(browser, sw/2-250, y, false)
		if progress >= 1 then
			state = "hidden"
			destroyElement(browser)
			showCursor(false)
			setElementData(localPlayer, "jobwindow", false)
		end
	end
end)

function createJobsBrowser(data)
	if getElementData(localPlayer, "jobwindow") then return end
	if isElement(browser) then return end
	browser = guiCreateBrowser(sw/2-250, sh, 500, 350, true, true, false)
	addEventHandler("onClientBrowserCreated", guiGetBrowser(browser), loadJobs)
	progress = 0
	details = data
	state = "showing"
	showCursor(true, false)
	setElementData(localPlayer, "jobwindow", true)
end
addEvent("createJobsWindow", true)
addEventHandler("createJobsWindow", getRootElement(), createJobsBrowser)

function destroyJobsBrowser()
	if not isElement(browser) then return end
	progress = 0
	state = "hiding"
end
addEvent("destroyJobsWindow", true)
addEventHandler("destroyJobsWindow", getRootElement(), destroyJobsBrowser)

function loadJobs()
	loadBrowserURL(source, "http://mta/local/html/job.html")
	setTimer(function ()
		local job_name = details[1]
		local job_desc = details[2]
		local job_button = "Zatrudnij się"
		if getElementData(localPlayer, "user:job") == details[3] then
			job_button = "Odbierz wynagrodzenie"
		end
		executeBrowserJavascript(guiGetBrowser(browser), "setJobDetails('"..job_name.."', '"..job_desc.."', '"..job_button.."')")
	end, 300, 1)
end

function acceptJob()
	if getElementData(localPlayer, "user:job") == details[3] then
		local money = math.floor(getElementData(localPlayer, "user:jobmoney"))
		if money < 1 then
			exports.rpg_noti:createNotification("error", "Nie posiadasz wynagrodzenia do odebrania")
		else
			exports.rpg_noti:createNotification("info", "Odbierasz wynagrodzenie w wysokości $"..money)
			setElementData(localPlayer, "user:jobmoney", 0)
			setElementData(localPlayer, "user:money", getElementData(localPlayer, "user:money") + money)
			triggerEvent("onClientPlayerPayday", localPlayer, money)
			triggerServerEvent("onPlayerPayday", getRootElement(), localPlayer, money)
		end
	elseif not getElementData(localPlayer, "user:job") or getElementData(localPlayer, "user:job") == 0 then
		if details[5] and (getElementData(localPlayer, "user:"..details[5]) < 1) then
			exports.rpg_noti:createNotification("error", "Nie posiadasz prawa jazdy kategorii "..string.gsub(details[5], "pj", ""))
			return
		end
		exports.rpg_noti:createNotification("info", "Zatrudniasz się jako "..details[4])
		setElementData(localPlayer, "user:job", details[3])
		triggerEvent("onPlayerStartJob", localPlayer, details[3])
		triggerServerEvent("onPlayerStartJob", localPlayer, details[3])
	else
		exports.rpg_noti:createNotification("error", "Posiadasz już inną pracę, aby się z niej zwolnij wpisz /resign")
	end
	destroyJobsBrowser()
end
addEvent("acceptJob", true)
addEventHandler("acceptJob", getRootElement(), acceptJob)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	setElementData(localPlayer, "jobwindow", false)
end)

addEvent("jobResign", true)
addEventHandler("jobResign", getRootElement(), function ()
	triggerServerEvent("playerResign", localPlayer, localPlayer, true)
end)

fileDelete("jobs_client.lua")