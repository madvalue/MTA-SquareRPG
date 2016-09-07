--[[
	Ciucholandy
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local sw, sh = guiGetScreenSize()
local browser
local state = "hidden"
local progress = 0
local y = sh

local skiny_premium = {
	[10]=true,
	[26]=true,
	[31]=true,
	[34]=true,
	[35]=true,
	[37]=true,
	[38]=true,
	[39]=true,
	[51]=true,
	[52]=true,
	[53]=true,
	[54]=true,
	[77]=true,
	[81]=true
}

function render()
	if state == "showing" then
		progress = progress + 0.07
		y,_,_ = interpolateBetween(sh, 0, 0, sh/2-270, 0, 0, progress, "Linear")
		guiSetPosition(browser, sw-400, y, false)
		if progress >= 1 then
			state = "showed"
			showCursor(true, false)
		end
	elseif state == "hiding" then
		progress = progress + 0.07
		y,_,_ = interpolateBetween(sh/2-270, 0, 0, sh, 0, 0, progress, "Linear")
		guiSetPosition(browser, sw-400, y, false)
		if progress >= 1 then
			state = "hidden"
			destroyElement(browser)
			removeEventHandler("onClientRender", getRootElement(), render)
		end
	end
end

function createCiucholandWindow()
	browser = guiCreateBrowser(sw-400, sh/2-270, 300, 540, true, true, false)
	addEventHandler("onClientBrowserCreated", guiGetBrowser(browser), loadCiucholand)
end
addEvent("createCiucholandWindow", true)
addEventHandler("createCiucholandWindow", getRootElement(), createCiucholandWindow)

function loadCiucholand()
	loadBrowserURL(source, "http://mta/local/html/ciucholand.html")
	progress = 0
	state = "showing"
	addEventHandler("onClientRender", getRootElement(), render)
end

function destroyCiucholandWindow()
	progress = 0
	state = "hiding"
	showCursor(false)
	local skin = getElementData(localPlayer, "user:skin")
	setElementModel(localPlayer, tonumber(skin))
end
addEvent("destroyCiucholandWindow", true)
addEventHandler("destroyCiucholandWindow", getRootElement(), destroyCiucholandWindow)

addEvent("setSkin", true)
addEventHandler("setSkin", getRootElement(), function (skin, ispremium)
	if skiny_premium[tonumber(skin)] and not getElementData(localPlayer, "user:premium") then
		exports.rpg_noti:createNotification("error", "Ten skin przeznaczony jest tylko dla graczy premium")
		return
	end
	setElementModel(localPlayer, skin)
end)

addEvent("saveSkin", true)
addEventHandler("saveSkin", getRootElement(), function ()
	local skin = getElementModel(localPlayer)
	if skiny_premium[tonumber(skin)] and not getElementData(localPlayer, "user:premium") then
		exports.rpg_noti:createNotification("error", "Ten skin przeznaczony jest tylko dla graczy premium")
		return
	end
	triggerServerEvent("savePlayerSkin", localPlayer, skin)
	destroyCiucholandWindow()
end)


fileDelete("ciucholand_client.lua")