--[[
	HUD
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local sw, sh = guiGetScreenSize()

addEventHandler("onClientRender", getRootElement(), function ()
	if not getElementData(localPlayer, "user:logged") then return end
	if isPlayerMapVisible() then return end
	
	local enabled = getElementData(localPlayer, "hud:enabled")
	if enabled then
		local y = 10
	
		--[[dxDrawText(formatClock(), sw-228, y+1, sw-9, 30, tocolor(0, 0, 0, 255), 1.3, "default", "right")
		dxDrawText(formatClock(), sw-228, y-1, sw-9, 30, tocolor(0, 0, 0, 255), 1.3, "default", "right")
		dxDrawText(formatClock(), sw-228, y+1, sw-11, 30, tocolor(0, 0, 0, 255), 1.3, "default", "right")
		dxDrawText(formatClock(), sw-228, y-1, sw-11, 30, tocolor(0, 0, 0, 255), 1.3, "default", "right")
		dxDrawText(formatClock(), sw-228, y, sw-10, 30, tocolor(255, 255, 255, 255), 1.3, "default", "right")
		y = y + 17]]
		
		
		local money = string.format("%09d", getElementData(localPlayer, "user:money"))
		dxDrawText("$"..money, sw-228, y+1, sw-9, 30, tocolor(0, 0, 0, 255), 1.8, "clear", "right")
		dxDrawText("$"..money, sw-228, y-1, sw-9, 30, tocolor(0, 0, 0, 255), 1.8, "clear", "right")
		dxDrawText("$"..money, sw-228, y+1, sw-11, 30, tocolor(0, 0, 0, 255), 1.8, "clear", "right")
		dxDrawText("$"..money, sw-228, y-1, sw-11, 30, tocolor(0, 0, 0, 255), 1.8, "clear", "right")
		dxDrawText("$"..money, sw-228, y, sw-10, 30, tocolor(255, 255, 255, 255), 1.8, "clear", "right")
		y = y + 35
	
		local hp = 216*(getElementHealth(localPlayer)/100)
		dxDrawEmptyRectangle(sw-230, y, 220, 20, tocolor(0, 0, 0, 255), 3)
		dxDrawLine(sw-228, y+10, sw-228+hp, y+10, tocolor(106, 153, 101, 255), 16)
		y = y + 30
		
		local armor = getPedArmor(localPlayer)
		if armor > 0 then
			dxDrawEmptyRectangle(sw-230, y, 220, 20, tocolor(0, 0, 0, 255), 3)
			dxDrawLine(sw-228, y+10, sw-228+(216*(armor/100)), y+10, tocolor(122, 125, 128, 255), 16)
			y = y + 30
		end
	
		if isPedInWater(localPlayer) then
			local oxygen = getPedOxygenLevel(localPlayer)
			dxDrawEmptyRectangle(sw-230, y, 220, 20, tocolor(0, 0, 0, 255), 3)
			dxDrawLine(sw-228, y+10, sw-228+(216*(oxygen/1000)), y+10, tocolor(0, 180, 247, 255), 16)
			y = y + 30
		end
		
		if isPedInVehicle(localPlayer) then
			local veh = getPedOccupiedVehicle(localPlayer)
			if veh then
				local speed = math.floor(getElementSpeed(veh, 1))
				local h = getVehicleHandling(veh)
				local p = speed/h['maxVelocity']
				if p > 1 then
					p = 1
				end
				local rspeed =166*p
			--	if (speed/h['maxVelocity']) > 0.75 then
					--r,g,b = interpolateBetween(12, 36, 25, 255, 10, 10, (p-0.75)/0.25, "Linear")
			--	else
					r,g,b = 91, 93, 116
				--end
				dxDrawEmptyRectangle(sw-200, sh-50, 170, 20, tocolor(0, 0, 0, 255), 3) -- Paliwo
				dxDrawLine(sw-198, sh-40, sw-32, sh-40, tocolor(0, 123, 240, 255), 16)
				
				dxDrawEmptyRectangle(sw-200, sh-75, 170, 20, tocolor(0, 0, 0, 255), 3) -- Zdrowie
				dxDrawLine(sw-198, sh-65, sw-(198-(166*(getElementHealth(veh)/1000))), sh-65, tocolor(106, 153, 101, 255), 16)
				
				dxDrawEmptyRectangle(sw-200, sh-100, 170, 20, tocolor(0, 0, 0, 255), 3) -- Prędkość
				dxDrawLine(sw-198, sh-90, sw-(198-rspeed), sh-90, tocolor(r,g,b, 255), 16)
				
				dxDrawText(math.floor(getElementHealth(veh)/10).."%", sw-198, sh-65, sw-32, sh-65, tocolor(255, 255, 255, 255), 1, "sans", "center", "center")
				dxDrawText(speed.."km/h", sw-198, sh-90, sw-32, sh-90, tocolor(255, 255, 255, 255), 1, "sans", "center", "center")
				dxDrawText("25 litrów", sw-198, sh-40, sw-32, sh-40, tocolor(255, 255, 255, 255), 1, "sans", "center", "center")
				
				local dist = string.format("%7.1f", getElementData(veh, "veh:distance"))
				dxDrawText(dist.."km", sw-258+2, sh-123+2, sw-32, sh-40, tocolor(0, 0, 0, 255), 1.2, "sans", "right")
				dxDrawText(dist.."km", sw-258-2, sh-123+2, sw-32, sh-40, tocolor(0, 0, 0, 255), 1.2, "sans", "right")
				dxDrawText(dist.."km", sw-258+2, sh-123-2, sw-32, sh-40, tocolor(0, 0, 0, 255), 1.2, "sans", "right")
				dxDrawText(dist.."km", sw-258-2, sh-123-2, sw-32, sh-40, tocolor(0, 0, 0, 255), 1.2, "sans", "right")
				dxDrawText(dist.."km", sw-258, sh-123, sw-32, sh-40, tocolor(255, 255, 255, 255), 1.2, "sans", "right")
				--dxDrawText(speed.."km/h", sw-258, sh-115, sw-32, sh-40, tocolor(255, 255, 255, 255), 2, "sans", "right")
			end
		end
	end
	
	for i,v in ipairs(getElementsByType("text")) do 
		local x1, y1, z1 = getElementPosition(v)
		local x2, y2, z2 = getElementPosition(localPlayer)
		local dist = getDistanceBetweenPoints3D(x1,y1,z1, x2,y2,z2)
		if dist < 30 then
			if isLineOfSightClear(x1,y1,z1, x2,y2,z2, true, true, true, true, false, false, true, getPedOccupiedVehicle(localPlayer) or localPlayer) then
				local sx,sy = getScreenFromWorldPosition(x1, y1, z1)
				if sx and sy then
					local text = getElementData(v, "text") or ""
					local scale = (getElementData(v, "scale") or 1.5)-(dist/40)
					dxDrawText(text, sx+2, sy-2, sx, sy, tocolor(0, 0, 0, 255), scale, "default", "center", "center")
					dxDrawText(text, sx-2, sy-2, sx, sy, tocolor(0, 0, 0, 255), scale, "default", "center", "center")
					dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(0, 0, 0, 255), scale, "default", "center", "center")
					dxDrawText(text, sx-2, sy+2, sx, sy, tocolor(0, 0, 0, 255), scale, "default", "center", "center")
					dxDrawText(text, sx, sy, sx, sy, tocolor(255, 255, 255, 255), scale, "default", "center", "center")
				end
			end
		end
	end
	
	for i,v in ipairs(getElementsByType("player")) do
		local x1, y1, z1 = getElementPosition(v)
		local x2, y2, z2 = getElementPosition(localPlayer)
		local dist = getDistanceBetweenPoints3D(x1,y1,z1+1.2, x2,y2,z2)
		if dist < 20 and v ~= localPlayer and getElementAlpha(v) == 255 then
			if isLineOfSightClear(x1,y1,z1+1.2, x2,y2,z2, true, false, true, true, false, false, true, getPedOccupiedVehicle(localPlayer) or localPlayer) then
				local sx,sy = getScreenFromWorldPosition(x1, y1, z1+1.2)
				if sx and sy then
					local text = getElementData(v, "user:username") or ""
					local id = getElementData(v, "user:tempid") or ""
					local level = getAdminLevelName(v)
					dxDrawText(level.."\n#ffffff"..text.." ["..id.."]", sx, sy, sx, sy, tocolor(255,255,255,255), 1, "default-bold", "center", "center", false, false, false, true)
				end
			end
		end
	end
	
	for i,v in ipairs(getElementsByType("ped")) do
		local x1, y1, z1 = getPedBonePosition(v, 8)
		local x2, y2, z2 = getElementPosition(localPlayer)
		local dist = getDistanceBetweenPoints3D(x1,y1,z1+0.3, x2,y2,z2)
		if dist < 30 then
			if isLineOfSightClear(x1,y1,z1+0.3, x2,y2,z2, true, false, false, true, false, false, true, getPedOccupiedVehicle(localPlayer) or localPlayer) then
				local sx,sy = getScreenFromWorldPosition(x1, y1, z1+0.4)
				if sx and sy then
					local text = getElementData(v, "name") or ""
					dxDrawText("(NPC)\n"..text, sx+2, sy-2, sx, sy, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center", false, false, false, false)
					dxDrawText("(NPC)\n"..text, sx-2, sy-2, sx, sy, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center", false, false, false, false)
					dxDrawText("(NPC)\n"..text, sx+2, sy+2, sx, sy, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center", false, false, false, false)
					dxDrawText("(NPC)\n"..text, sx-2, sy+2, sx, sy, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center", false, false, false, false)
					dxDrawText("#ffc800(NPC)\n#ffffff"..text, sx, sy, sx, sy, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", false, false, false, true)
				end
			end
		end
	end
end)

function formatClock()
	local hour, minute = getTime()
	hour = string.format("%02d", hour)
	minute = string.format("%02d", minute)
	return hour..":"..minute
end

function dxDrawEmptyRectangle(x,y,w,h,c,g)
	dxDrawLine(x,y,x+w,y,c, g)
	dxDrawLine(x,y+h,x+w,y+h,c,g)
	dxDrawLine(x,y,x,y+h,c,g)
	dxDrawLine(x+w,y,x+w,y+h,c,g)
end

function dxDrawCircle( posX, posY, radius, width, angleAmount, startAngle, stopAngle, color, postGUI )
	if ( type( posX ) ~= "number" ) or ( type( posY ) ~= "number" ) then
		return false
	end
 
	local function clamp( val, lower, upper )
		if ( lower > upper ) then lower, upper = upper, lower end
		return math.max( lower, math.min( upper, val ) )
	end
 
	radius = type( radius ) == "number" and radius or 50
	width = type( width ) == "number" and width or 5
	angleAmount = type( angleAmount ) == "number" and angleAmount or 1
	startAngle = clamp( type( startAngle ) == "number" and startAngle or 0, 0, 360 )
	stopAngle = clamp( type( stopAngle ) == "number" and stopAngle or 360, 0, 360 )
	color = color or tocolor( 255, 255, 255, 200 )
	postGUI = type( postGUI ) == "boolean" and postGUI or false
 
	if ( stopAngle < startAngle ) then
		local tempAngle = stopAngle
		stopAngle = startAngle
		startAngle = tempAngle
	end
 
	for i = startAngle, stopAngle, angleAmount do
		local startX = math.cos( math.rad( i ) ) * ( radius - width )
		local startY = math.sin( math.rad( i ) ) * ( radius - width )
		local endX = math.cos( math.rad( i ) ) * ( radius + width )
		local endY = math.sin( math.rad( i ) ) * ( radius + width )
 
		dxDrawLine( startX + posX, startY + posY, endX + posX, endY + posY, color, width, postGUI )
	end
 
	return true
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	showPlayerHudComponent("clock", false)
	showPlayerHudComponent("health", false)
	showPlayerHudComponent("armour", false)
	showPlayerHudComponent("breath", false)
	showPlayerHudComponent("money", false)
	showPlayerHudComponent("weapon", false)
	showPlayerHudComponent("ammo", false)
	showPlayerHudComponent("area_name", false)
	showPlayerHudComponent("vehicle_name", false)
end)

function getAdminLevelName(player)
	local level = getElementData(player, "user:admin")
	if not getElementData(player, "user:aduty") then return "" end
	if level == 1 then
		return "#ff0000ADMIN"
	elseif level == 2 then
		return "#00B7EBSUPPORT"
	else
		if getElementData(player, "user:premium") then
			return "#ffc800PREMIUM"
		else
			return ""
		end
	end
end

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle", "Invalid element type @ getElementSpeed (player/ped/object/vehicle expected, got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

fileDelete("hud_client.lua")