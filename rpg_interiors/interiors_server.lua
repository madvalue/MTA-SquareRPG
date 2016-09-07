--[[
	System budynków
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
addEventHandler("onResourceStart", resourceRoot, function ()
	exports.rpg_mysql:mysql_query("SET NAMES utf8")
	
	local q = exports.rpg_mysql:mysql_query("SELECT * FROM rpg_interiors")
	for i,v in ipairs(q) do
		local p1 = split(v.en_marker, ",")
		local marker_en = createMarker(p1[1], p1[2], p1[3]+0.7, "arrow", 1.2, 255, 200, 0, 150)
		setElementInterior(marker_en, p1[4])
		setElementDimension(marker_en, p1[5])
		
		local cs_en = createColSphere(p1[1], p1[2], p1[3], 1)
		setElementInterior(cs_en, p1[4])
		setElementDimension(cs_en, p1[5])
		setElementData(cs_en, "data", v)
		
		local p2 = split(v.ex_marker, ",")
		local marker_ex = createMarker(p2[1], p2[2], p2[3]+0.7, "arrow", 1.2, 255, 200, 0, 150)
		setElementInterior(marker_ex, p2[4])
		setElementDimension(marker_ex, p2[5])
		
		local cs_ex = createColSphere(p2[1], p2[2], p2[3], 1)
		setElementInterior(cs_ex, p2[4])
		setElementDimension(cs_ex, p2[5])
		setElementData(cs_ex, "data", v)
		
		
		local t = createElement("text")
		setElementPosition(t, p1[1], p1[2], p1[3]+1.3)
		setElementData(t, "text", v.name)
		
		addEventHandler("onColShapeHit", cs_en, hit_enter)
		addEventHandler("onColShapeHit", cs_ex, hit_exit)
	end
end)

function hit_enter(hit)
	if getElementType(hit) ~= "player" then return end
	if isPedInVehicle(hit) then return end
	local v = getElementData(source, "data")
	if v.locked ~= 0 then
		exports.rpg_noti:createNotification(hit, "error", "Ten budynek jest zamknięty")
		return
	end
	local tp = split(v.en_tp, ",")
	fadeCamera(hit ,false)
	setElementFrozen(hit, true)
	setTimer(function ()
		setElementPosition(hit, tp[1], tp[2], tp[3])
		setElementRotation(hit, 0, 0, tp[4])
		setElementInterior(hit, tp[5])
		setElementDimension(hit, tp[6])
		setElementFrozen(hit, false)
		showPlayerHudComponent(hit, "radar", false)
		fadeCamera(hit, true)
	end, 1500, 1)
end


function hit_exit(hit)
	if getElementType(hit) ~= "player" then return end
	if isPedInVehicle(hit) then return end
	local v = getElementData(source, "data")
	if v.locked ~= 0 then
	--	exports.rpg_noti:createNotification(hit, "error", "Ten budynek jest zamknięty")
	--	return
	end
	local tp = split(v.ex_tp, ",")
	fadeCamera(hit, false)
	setElementFrozen(hit, true)
	setTimer(function ()
		setElementPosition(hit, tp[1], tp[2], tp[3])
		setElementRotation(hit, 0, 0, tp[4])
		setElementInterior(hit, tp[5])
		setElementDimension(hit, tp[6])
		showPlayerHudComponent(hit, "radar", true)
		setElementFrozen(hit, false)
		fadeCamera(hit, true)
	end, 1500, 1)
end