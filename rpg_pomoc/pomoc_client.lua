--[[
	System pomocy
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local sw,sh = guiGetScreenSize()
local browser
local state = "hidden"
local y = sh
function render()
	if state == "showing" then
		progress = progress + 0.09
		y,_,_ = interpolateBetween(sh, 0, 0, sh/2-200, 0, 0, progress, "Linear")
		guiSetPosition(browser, sw/2-325, y, false)
		if progress >= 1 then
			state = "showed"
		end
	elseif state =="hiding" then
		progress = progress + 0.09
		y,_,_ = interpolateBetween(sh/2-200, 0, 0, sh, 0, 0, progress, "Linear")
		guiSetPosition(browser, sw/2-325, y, false)
		if progress >= 1 then
			state = "hidden"
			destroyElement(browser)
			removeEventHandler("onClientRender", getRootElement(), render)
		end
	end
end

function openHelpWindow()
	if isElement(browser) then return end
	if not getElementData(localPlayer, "user:logged") then return end
	browser = guiCreateBrowser(sw/2-325, y, 650, 400, true, true, false)
	addEventHandler("onClientBrowserCreated", guiGetBrowser(browser), loadHelp)
	showCursor(true)
end

function closeHelpWindow()
	if isElement(browser) then
		progress = 0
		state = "hiding"
		showCursor(false)
	end
end

bindKey("F1", "down", function ()
	if state == "showed" then
		closeHelpWindow()
	else
		openHelpWindow()
	end
end)

function loadHelp()
	loadBrowserURL(source, "http://mta/local/html/pomoc.html")
	progress = 0
	state = "showing"
	addEventHandler("onClientRender", getRootElement(), render)
end