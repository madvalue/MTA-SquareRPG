--[[
	System powiadomień
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local sw, sh = guiGetScreenSize()
local notifications = {}
local i = 1

function createNotification(type, text)
	local id = #notifications+1
	local color
	if type == "info" then
		color = tocolor(255, 255, 255, 255)
		outputConsole("[INFO] "..text)
	elseif type == "error" then
		color = tocolor(255, 0, 0, 255)
		outputConsole("[ERROR] "..text)
	end
	table.insert(notifications, {text, color})
	setTimer(function ()
		table.remove(notifications, 1)
	end, 2000, 1)
end
addEvent("createNotification", true)
addEventHandler("createNotification", getRootElement(), createNotification)

addEventHandler("onClientRender", getRootElement(), function ()
	for i,v in ipairs(notifications) do
		dxDrawRectangle(0,(i*29)-29, sw, 30, tocolor(0, 0, 0, 150))
		dxDrawText(v[1], 0, (i*29)-25, sw, 25, v[2], 1.3, "default", "center")
	end
end)

fileDelete("noti_client.lua")