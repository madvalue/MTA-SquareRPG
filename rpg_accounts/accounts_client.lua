--[[
	System kont graczy w oparciu o MySQL
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local sw,sh = guiGetScreenSize()
local browser

local state = false

local logo_progress = 0
local logo_state = "stop"
local logo_t = 100

local browser_progress = 0
local browser_state = "hidden"
local browser_y = sh+50

function render()
	
		if browser_state == "showing" then
			browser_progress = browser_progress + 0.04
			browser_y,_,_ = interpolateBetween(sh+50, 0, 0, sh/2-175, 0, 0, browser_progress, "Linear")
			guiSetPosition(browser, sw/2-250, browser_y, false)
			if browser_progress >= 1 then
				browser_state = "showed"
			end
		elseif browser_state == "hiding" then
			browser_progress = browser_progress + 0.04
			browser_y,_,_ = interpolateBetween(sh/2-175, 0, 0, sh+50, 0, 0, browser_progress, "Linear")
			guiSetPosition(browser, sw/2-250, browser_y, false)
			if browser_progress >= 1 then
				browser_state = "hidden"
				if state == "toregister" then
					createBrowserRegister()
				elseif state == "tologin" then
					createBrowserLogin()
				elseif state == "destroyLogin" then
					destroyElement(browser)
					removeEventHandler("onClientRender", getRootElement(), render)
					showCursor(false)
				end
			end
		end

end

function createLoginPanel()
	addEventHandler("onClientRender", getRootElement(), render)
	setCameraMatrix(-2429.14673, -558.53143, 131.19682, -2445.45410, -446.53268, 109.61346)
	showCursor(true)
	showChat(false)
	showPlayerHudComponent("radar", false)
	setElementData(localPlayer, "hud:enabled", false)
	createBrowserLogin()
	fadeCamera(true)
end
addEventHandler("onClientResourceStart", resourceRoot, createLoginPanel)


-----------------------
---- LOGOWANIE ----
-----------------------
function createBrowserLogin()
	state = "login"

	browser = guiCreateBrowser(sw/2-250, browser_y, 500, 350, true, true, false)
	addEventHandler("onClientBrowserCreated", guiGetBrowser(browser), loadBrowserLogin)
end

function loadBrowserLogin()
	loadBrowserURL(source, "http://mta/local/html/login.html")
	browser_progress = 0
	browser_state = "showing"
end
	
function switchRegister()
	browser_progress = 0
	browser_state = "hiding"
	state = "toregister"
end
addEvent("switchRegister", true)
addEventHandler("switchRegister", getRootElement(), switchRegister)

addEvent("yolo", true)
addEventHandler("yolo", getRootElement(), function ()
	outputChatBox('YOLO')
end)

function processLogin(username, password)
	if username:len() < 3 then
		exports.rpg_noti:createNotification("error", "Nazwa użytkownika powinna zawierać przynajmniej 3 znaki")
	elseif password:len() < 3 then
		exports.rpg_noti:createNotification("error", "Hasło powinno zawierać przynajmniej 3 znaki")
	else
		triggerServerEvent("auth", localPlayer, username, password)
	end
end
addEvent("processLogin", true)
addEventHandler("processLogin", getRootElement(), processLogin)

function destroyLogin()
	state = "destroyLogin"
	browser_progress = 0
	browser_state = "hiding"
end
addEvent("destroyLogin", true)
addEventHandler("destroyLogin", getRootElement(), destroyLogin)


------------------------
---- REJESTRACJA ----
------------------------
function createBrowserRegister()
	state = "register"
	
	destroyElement(browser)
	
	browser = guiCreateBrowser(sw/2-250, browser_y, 500, 350, true, true, false)
	addEventHandler("onClientBrowserCreated", guiGetBrowser(browser), loadBrowserRegister)
	
	browser_progress = 0
	browser_state = "showing"
end

function loadBrowserRegister()
	loadBrowserURL(source, "http://mta/local/html/register.html")
end

function switchLogin()
	browser_progress = 0
	browser_state = "hiding"
	state = "tologin"
end
addEvent("switchLogin", true)
addEventHandler("switchLogin", getRootElement(), switchLogin)

function processRegister(username, password, email)
	if username:len() < 3 then
		exports.rpg_noti:createNotification("error", "Nazwa użytkownika powinna zawierać przynajmniej 3 znaki")
	elseif password:len() < 3 then
		exports.rpg_noti:createNotification("error", "Hasło powinno zawierać przynajmniej 3 znaki")
	--elseif email:len() < 3 then
		--exports.rpg_noti:createNotification("error", "Adres E-Mail powinien zawierać przynajmniej 3 znaki")
	elseif not isValidMail(email) then
		exports.rpg_noti:createNotification("error", "Proszę podać prawidłowy adres E-Mail")
	else
		triggerServerEvent("register", localPlayer, username, password, email)
	end
end
addEvent("processRegister", true)
addEventHandler("processRegister", getRootElement(), processRegister)

addEvent("onPlayerAccountLogin", true)

function isValidMail( mail )
    assert( type( mail ) == "string", "Bad argument @ isValidMail [string expected, got " .. tostring( mail ) .. "]" )
    return mail:match( "[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?" ) ~= nil
end


fileDelete("accounts_client.lua")