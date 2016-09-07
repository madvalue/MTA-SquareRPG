--[[
	Przechowywalnie
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local sw,sh = guiGetScreenSize()
local window
local przecho_browser
local przecho_y = sh
local przecho_progress = 0
local przecho_state = "hidden"
local vehicles = false

function render()
	if przecho_state == "showing" then
		przecho_progress = przecho_progress + 0.05
		przecho_y,_,_ = interpolateBetween(sh, 0, 0, sh/2-275, 0, 0, przecho_progress, "Linear")
		guiSetPosition(przecho_browser, sw-600, przecho_y, false)
		if przecho_progress >= 1 then
			przecho_state = "showed"
		end
	elseif przecho_state == "hiding" then
		przecho_progress = przecho_progress + 0.1
		przecho_y,_,_ = interpolateBetween(sh/2-275, 0, 0, sh, 0, 0, przecho_progress, "Linear")
		guiSetPosition(przecho_browser, sw-600, przecho_y, false)
		if przecho_progress >= 1 then
			przecho_state = "hidden"
			destroyElement(przecho_browser)
			removeEventHandler("onClientRender", getRootElement(), render)
		end
	end
end

function openPrzechoWindow(q)
	if isElement(window) then return end

	--[[window = guiCreateWindow(sw-400, sh/2-200, 300, 400, "Odbiór pojazdów", false)
	grid = guiCreateGridList(0, 0.06, 1, 0.75, true, window)
	col1 = guiGridListAddColumn(grid, "Nazwa pojazdu", 0.5)
	col2 = guiGridListAddColumn(grid, "Zdrowie", 0.25)
	col3 = guiGridListAddColumn(grid, "Bak", 0.15)
	button_accept = guiCreateButton(0, 0.82, 1, 0.07, "Wybierz", true, window)
	button_close = guiCreateButton(0, 0.9, 1, 0.07, "Zamknij", true, window)
	
	for i,v in ipairs(q) do
		local row = guiGridListAddRow(grid)
		guiGridListSetItemText(grid, row, col1, exports.rpg_vehicles:getVehicleCustomName(v.model), false, false)
		guiGridListSetItemText(grid, row, col2, "100%", false, false)
		guiGridListSetItemText(grid, row, col3, "25l", false, false)
		guiGridListSetItemData(grid, row, col1, v.uid, false, false)
	end
	
	addEventHandler("onClientGUIDoubleClick", grid, clickAccept)
	addEventHandler("onClientGUIClick", button_accept, clickAccept)
	addEventHandler("onClientGUIClick", button_close, closePrzechoWindow)]]
	
	addEventHandler("onClientRender", getRootElement(), render)
	
	vehicles = q
	
	przecho_progress = 0
	przecho_state = "showing"
	
	przecho_browser = guiCreateBrowser(sw-600, sh, 550, 550, true, true, false)
	addEventHandler("onClientBrowserCreated", guiGetBrowser(przecho_browser), load)
	
	showCursor(true, false)
end
addEvent("showPrzechoWindow", true)
addEventHandler("showPrzechoWindow", getRootElement(), openPrzechoWindow)

function load()
	loadBrowserURL(source, "http://mta/local/html/przecho.html")
	setTimer(function ()
		for i,v in ipairs(vehicles) do
			executeBrowserJavascript(guiGetBrowser(przecho_browser), "addVehicle('"..exports.rpg_vehicles:getVehicleCustomName(v.model).."', '"..(v.uid).."')")
		end
	end, 300, 1)
end

function clickAccept(uid)
	if not uid then return end
	triggerServerEvent("odbierzPojazd", root, localPlayer, uid)
end
addEvent("clickAccept", true)
addEventHandler("clickAccept", getRootElement(), clickAccept)

function closePrzechoWindow()
	if isElement(przecho_browser) then
		przecho_progress = 0
		przecho_state = "hiding"
		showCursor(false)
	end
end
addEvent("destroyPrzechoWindow", true)
addEventHandler("destroyPrzechoWindow", getRootElement(), closePrzechoWindow)

fileDelete("przecho_client.lua")