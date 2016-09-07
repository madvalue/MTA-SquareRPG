--[[
	System administratorów
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local sw,sh = guiGetScreenSize()

local echo = {}

local ann_timer = false
local ann = false
local ann_text = ""
local ann_text2 = ""

local warned_timer = false
local warned = false
local warned_text = ""

function createWarn(text)
	if isElement(warned_timer) then
		killTimer(warned_timer)
	end
	warned = true
	warned_text = text
	
	warned_timer = setTimer(function ()
		warned = false
	end, 5000, 1)
end
addEvent("createWarn", true)
addEventHandler("createWarn", getRootElement(), createWarn)

function createAnn(text, text2)
	if isElement(ann_timer) then
		killTimer(ann_timer)
	end
	ann = true
	ann_text = text
	ann_text2 = text2
	
	outputConsole(text)
	outputConsole(text2)
	
	ann_timer = setTimer(function ()
		ann = false
	end, 6000, 1)
end
addEvent("createAnn", true)
addEventHandler("createAnn", getRootElement(), createAnn)

function doesHaveAdminPerms(player, perm)
	local t = getElementData(player, "user:aperm")
	if not t then return false end
	if tonumber(t[perm]) > 0 then
		return true
	else
		return false
	end
end

function addToEcho(text)
	if #echo > 13 then
		table.remove(echo, 1)
	end
	table.insert(echo, text)
end
addEvent("addToEcho", true)
addEventHandler("addToEcho", getRootElement(), addToEcho)

addEventHandler("onClientRender", getRootElement(), function ()
	if not getElementData(localPlayer, "user:logged") then return end
	if warned then
		dxDrawText("Otrzymałeś/aś ostrzeżenie!", 0, 0, sw+3, sh/2+100-3, tocolor(0, 0, 0, 255), 4, "default", "center", "center")
		dxDrawText("Otrzymałeś/aś ostrzeżenie!", 0, 0, sw-3, sh/2+100-3, tocolor(0, 0, 0, 255), 4, "default", "center", "center")
		dxDrawText("Otrzymałeś/aś ostrzeżenie!", 0, 0, sw+3, sh/2+100+3, tocolor(0, 0, 0, 255), 4, "default", "center", "center")
		dxDrawText("Otrzymałeś/aś ostrzeżenie!", 0, 0, sw-3, sh/2+100+3, tocolor(0, 0, 0, 255), 4, "default", "center", "center")
		dxDrawText("Otrzymałeś/aś ostrzeżenie!", 0, 0, sw, sh/2+100, tocolor(255, 0, 0, 255), 4, "default", "center", "center")
		
		dxDrawText(warned_text, sw/2-300, sh/2-180+1, sw/2+300-1, sh, tocolor(0, 0, 0, 255), 2, "default", "center", "top", true, true)
		dxDrawText(warned_text, sw/2-300, sh/2-180-1, sw/2+300-1, sh, tocolor(0, 0, 0, 255), 2, "default", "center", "top", true, true)
		dxDrawText(warned_text, sw/2-300, sh/2-180+1, sw/2+300+1, sh, tocolor(0, 0, 0, 255), 2, "default", "center", "top", true, true)
		dxDrawText(warned_text, sw/2-300, sh/2-180-1, sw/2+300+1, sh, tocolor(0, 0, 0, 255), 2, "default", "center", "top", true, true)
		dxDrawText(warned_text, sw/2-300, sh/2-180, sw/2+300, sh, tocolor(255, 255, 255, 255), 2, "default", "center", "top", true, true)
	end
	
	if ann then
		local w1 = dxGetTextWidth(ann_text, 1.15)
		local w2 = dxGetTextWidth(ann_text2, 1.15)
		local w
		if w1 > w2 then
			w = w1
		else
			w = w2
		end
		dxDrawRectangle(5, sh-50, w+20, 47, tocolor(0, 0, 0, 200))
		dxDrawText(ann_text, 15, sh-45, 0, 0, tocolor(255, 0, 0, 255), 1.15)
		dxDrawText(ann_text2, 15, sh-27, 0, 0, tocolor(255, 0, 0, 255), 1.15)
	end
	
	if getElementData(localPlayer, "user:aecho") then
		local echo_text = ""
		for i,v in ipairs(echo) do
			echo_text = echo_text.."\n"..v
		end
	
		dxDrawRectangle(3, sh/2+8, 400, 20, tocolor(0, 0, 0, 150))
		dxDrawText("ECHO (aby wyłączyć wpisz /echo)", 10, sh/2+10, 400, 50, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", false, true)
		dxDrawText(echo_text, 10, sh/2+14, 400, 50, tocolor(255, 255, 255, 255), 1, "default", "left", "top", false, true)
	end
end)

fileDelete("admin_client.lua")