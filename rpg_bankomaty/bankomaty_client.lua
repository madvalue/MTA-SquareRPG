--[[
	Bankomaty
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local sw,sh = guiGetScreenSize()
local browser
local state = "hidden"
local progress = 0
local y = sh

function render()
	if state == "showing" then
		progress = progress + 0.1
		y,_,_ = interpolateBetween(sh, 0, 0, sh/2-175, 0, 0, progress, "Linear")
		guiSetPosition(browser, sw/2-225, y, false)
		if progress >= 1 then
			state = "showed"
			showCursor(true, false)
		end
	elseif state == "hiding" then
		progress = progress + 0.1
		y,_,_ = interpolateBetween(sh/2-175, 0, 0, sh, 0, 0, progress, "Linear")
		guiSetPosition(browser, sw/2-225, y, false)
		if progress >= 1 then
			state = "hidden"
			removeEventHandler("onClientRender", getRootElement(), render)
			destroyElement(browser)
		end
	end
end

function createATMWindow()
	if isElement(browser) then return end
	browser = guiCreateBrowser(sw/2-225, y, 550, 350, true, true, false)
	addEventHandler("onClientBrowserCreated", guiGetBrowser(browser), load)
end
addEvent("createATMWindow", true)
addEventHandler("createATMWindow", getRootElement(), createATMWindow)

function destroyATMWindow()
	progress = 0
	state = "hiding"
	showCursor(false)
end
addEvent("destroyATMWindow", true)
addEventHandler("destroyATMWindow", getRootElement(), destroyATMWindow)

function load()
	loadBrowserURL(source, "http://mta/local/html/bankomat.html")
	progress = 0
	state = "showing"
	addEventHandler("onClientRender", getRootElement(), render)
	setTimer(function ()
		local bankmoney = getElementData(localPlayer, "user:bankmoney")
		executeBrowserJavascript(guiGetBrowser(browser), "loadATM("..bankmoney..")")
	end, 300, 1)
end

function atm_deposit(i)
	local money = getElementData(localPlayer, "user:money")
	local bankmoney = getElementData(localPlayer, "user:bankmoney")
	if not tonumber(i) then
		exports.rpg_noti:createNotification("error", "Wprowadzona wartość musi być liczbą")
		return
	end
	local i = tonumber(i)
	if i < 1 then
		exports.rpg_noti:createNotification("error", "Wprowadzona wartość musi być większa od 0")
		return
	end
	if i >money then
		exports.rpg_noti:createNotification("error", "Nie posiadasz przy sobie takiej sumy")
		return
	end
	setElementData(localPlayer, "user:bankmoney", bankmoney+i)
	setElementData(localPlayer, "user:money", money-i)
	executeBrowserJavascript(guiGetBrowser(browser), "loadATM("..getElementData(localPlayer, "user:bankmoney")..")")
end
addEvent("atmDeposit", true)
addEventHandler("atmDeposit", getRootElement(), atm_deposit)

function atm_withdraw(i)
	local money = getElementData(localPlayer, "user:money")
	local bankmoney = getElementData(localPlayer, "user:bankmoney")
	if not tonumber(i) then
		exports.rpg_noti:createNotification("error", "Wprowadzona wartość musi być liczbą")
		return
	end
	local i = tonumber(i)
	if i < 1 then
		exports.rpg_noti:createNotification("error", "Wprowadzona wartość musi być większa od 0")
		return
	end
	if i > bankmoney then
		exports.rpg_noti:createNotification("error", "Nie posiadasz takiej sumy na swoim koncie")
		return
	end
	setElementData(localPlayer, "user:bankmoney", bankmoney-i)
	setElementData(localPlayer, "user:money", money+i)
	executeBrowserJavascript(guiGetBrowser(browser), "loadATM("..getElementData(localPlayer, "user:bankmoney")..")")
end
addEvent("atmWithdraw", true)
addEventHandler("atmWithdraw", getRootElement(), atm_withdraw)

fileDelete("bankomaty_client.lua")