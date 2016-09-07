--[[
	Egzamin na prawo jazdy
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local sw,sh = guiGetScreenSize()
local browser
local state = "hidden"
local y = sh
local progress = 0
local pkt = 1
local marker,blip

local pj_cs = createColSphere(-2047.0244140625, -96.7998046875, 34.684188842773, 3)
local pja_pkt = {
	{-2047.0361328125, -82.126953125, 34.684188842773, text="Dobrzę, proszę skręcić w prawo i skierować się w stronę przejazdu kolejowego"},
	{-2032.8056640625, -72.25390625, 34.692031860352},
	{-1996.0576171875, -72.5205078125, 34.567329406738, text="Proszę przed przejazdem się zatrzymać oraz upewnić, że można bezpiecznie przejechać"},
	{-1962.3173828125, -66.2666015625, 25.210969924927},
	{-1923.4970703125, -72.4541015625, 25.074174880981},
	{-1848.505859375, -118.49609375, 5.0855555534363, text="Tutaj proszę skręcić w prawo"},
	{-1839.3818359375, -130.408203125, 5.2338552474976},
	{-1839.0322265625, -174.166015625, 8.7700834274292},
	{-1838.9169921875, -223.52734375, 17.735994338989, text="Tutaj jeszcze raz w prawo"},
	{-1850.0439453125, -234.0185546875, 17.74652671814},
	{-1944.873046875, -238.1064453125, 25.081382751465, text="Proszę upewnić się, czy można bezpiecznie przejechać i przy pierwszej możliwości jechać w lewo"},
	{-2007.7421875, -247.78125, 35.174461364746},
	{-2024.3291015625, -311.3896484375, 34.840839385986, text="Proszę włączyć się do ruchu na autostradzie i kierować się w stronę klubu golfowego"},
	{-2054.4599609375, -329.7822265625, 34.833881378174, limit=false, size=3},
	{-2144.1435546875, -332.591796875, 34.63166809082, limit=false, size=3},
	{-2274.595703125, -332.12109375, 39.097713470459, limit=false, size=3},
	{-2557.166015625, -329.3193359375, 24.520235061646, limit=false, size=3},
	{-2698.7119140625, -381.85546875, 7.8763084411621, limit=false, size=3},
	{-2791.0712890625, -468.3193359375, 6.6942043304443, limit=false, size=3, text="Proszę zjechać z autostrady i dalej jechać w stronę klubu"},
	{-2808.6650390625, -467.111328125, 6.6459522247314},
	{-2819.375, -422.6171875, 6.560555934906},
	{-2811.7314453125, -318.181640625, 6.5513153076172, text="Świetnie Ci idzie, przy najbliższym skręcie proszę w prawo, a następnie cały czas prosto"},
	{-2807.7705078125, -221.3134765625, 6.549289226532},
	{-2796.6845703125, -212.8291015625, 6.5590953826904},
	{-2667.791015625, -212.1162109375, 3.6988146305084},
	{-2494.244140625, -212.8017578125, 24.986450195313},
	{-2420.3232421875, -188.546875, 34.686328887939},
	{-2419.185546875, -84.208984375, 34.684635162354, text="Tutaj w prawo i będziemy kierowali się już w stronę ośrodka"},
	{-2384.8291015625, -72.4931640625, 34.684078216553},
	{-2239.0859375, -72.6748046875, 34.687507629395},
	{-2148.1328125, -72.69921875, 34.693347930908},
	{-2060.5087890625, -72.7255859375, 34.690441131592, text="Dobrze, tutaj w prawo i na parking"},
	{-2047.0244140625, -96.7998046875, 34.684188842773, size=5},
}

local pjb_pkt = {
	{-2046.880859375, -84.5166015625, 34.997886657715, text="Proszę skręcić w lewo, a następnie prosto"},
	{-2072.751953125, -67.974609375, 35.005672454834},
	{-2154.2880859375, -68.423828125, 35.005710601807, text="Tutaj w prawo po czym cały czas prosto"},
	{-2163.919921875, -35.3349609375, 35.007110595703},
	{-2164.8525390625, 44.5888671875, 35.006011962891},
	{-2149.943359375, 124.841796875, 35.005821228027},
	{-2144.4677734375, 194.50390625, 35.042953491211, text="Tutaj proszę w lewo, na następnym skręcie znów w lewo"},
	{-2159.615234375, 210.6826171875, 35.005863189697},
	{-2238.1435546875, 210.8408203125, 35.005844116211},
	{-2254.60546875, 192.3896484375, 35.009666442871},
	{-2255.603515625, 92.4208984375, 35.005687713623},
	{-2260.4501953125, -54.6669921875, 35.005828857422, text="Tutaj proszę w prawo, a następnie cały czas prosto"},
	{-2274.0947265625, -68.0322265625, 34.998188018799},
	{-2358.0341796875, -68.056640625, 34.997936248779},
	{-2507.2646484375, -68.2294921875, 25.387449264526},
	{-2616.6748046875, -68.9150390625, 4.0190591812134},
	{-2693.65625, -68.4833984375, 4.0135364532471, text="Jak narazie świetnie Ci idzie, tutaj w lewo"},
	{-2708.6240234375, -82.966796875, 4.0211930274963},
	{-2708.2109375, -198.1513671875, 4.0137448310852, text="Tutaj w lewo i cały czas prosto w stronę bazy kurierskiej"},
	{-2667.45703125, -212.587890625, 4.0137476921082},
	{-2492.5693359375, -212.48046875, 25.370460510254},
	{-2419.0283203125, -176.7353515625, 35.005973815918},
	{-2419.02734375, -83.1962890625, 35.005588531494, text="Teraz w prawo, na następnym skręcie to samo"},
	{-2399.5419921875, -72.3427734375, 34.998260498047},
	{-2374.4306640625, -84.46484375, 35.005603790283},
	{-2368.9423828125, -176.9677734375, 35.005741119385, text="Po lewej mamy właśnie magazyn kurierski"},
	{-2273.7607421875, -192.7197265625, 35.005905151367, text="Teraz już prosto do ośrodka"},
	{-2192.4892578125, -191.2958984375, 35.005908966064},
	{-2165.146484375, -84.529296875, 35.005619049072},
	{-2113.9443359375, -72.6494140625, 35.006107330322},
	{-2060.2373046875, -72.3662109375, 35.006038665771},
	{-2046.9765625, -96.9765625, 35.001842498779, size=5},
}

local pjc_pkt = {
	{-2046.9375, -84.5888671875, 35.257698059082, text="Najpierw proszę skręcić w lewo, po czym znów w lewo"},
	{-2033.3388671875, -72.896484375, 35.265647888184},
	{-2004.5498046875, -56.33203125, 35.25870513916},
	{-2004.666015625, 14.10546875, 33.192085266113, text="Teraz proszę cały czas prosto"},
	{-2003.626953125, 91.4189453125, 27.632850646973, text="Tutaj proszę w lewo, a następnie prosto i w prawo"},
	{-2020.076171875, 110.6982421875, 27.779367446899},
	{-2141.033203125, 111.3232421875, 35.265628814697},
	{-2148.2734375, 132.259765625, 35.265617370605},
	{-2144.4462890625, 194.6455078125, 35.302051544189, text="Tutaj w lewo, a następnie w prawo"},
	{-2160.6240234375, 210.4169921875, 35.264938354492},
	{-2239.462890625, 209.72265625, 35.265655517578},
	{-2248.9365234375, 224.1142578125, 35.257816314697},
	{-2249.037109375, 307.4345703125, 35.257846832275, text="Teraz w lewo i cały czas prosto"},
	{-2266.5380859375, 322.6318359375, 35.667343139648},
	{-2546.6455078125, 160.2568359375, 4.275340080261, text="Tutaj w prawo i zaraz po tym w lewo"},
	{-2559.5302734375, 172.1689453125, 4.6090850830078},
	{-2573.21875, 217.0615234375, 9.0058431625366},
	{-2630.091796875, 219.7822265625, 4.4545917510986},
	{-2692.462890625, 220.046875, 4.2734656333923, text="Tutaj proszę skręcić w lewo i jechać cały czas prosto"},
	{-2708.2275390625, 197.9833984375, 4.2734470367432},
	{-2708.15234375, 142.3505859375, 4.273832321167},
	{-2708.00390625, 70.6396484375, 4.2730584144592},
	{-2708.5283203125, -17.4384765625, 4.2734394073486},
	{-2707.9580078125, -84.123046875, 4.2783794403076},
	{-2708.3896484375, -197.89453125, 4.2733173370361, text="Tutaj w prawo, następnie kawałek prosto i w lewo"},
	{-2796.0078125, -208.0078125, 7.1293115615845},
	{-2811.8310546875, -231.5205078125, 7.1250820159912},
	{-2819.0146484375, -344.087890625, 7.1243677139282},
	{-2805.8232421875, -474.849609375, 7.2809519767761, text="Dobrze, proszę włączyć się do ruchu po czym kierować się w stronę miasta"},
	{-2776.1435546875, -478.7275390625, 7.298415184021, size=4},
	{-2661.9130859375, -380.5751953125, 10.418348312378, size=4},
	{-2231.052734375, -350.046875, 37.906452178955, size=4},
	{-2065.63671875, -350.072265625, 35.39847946167, size=4, text="Tutaj zjedź w kierunku ośrodka, pamiętaj o zachowaniu ostrożności!"},
	{-2023.5390625, -316.337890625, 35.31774520874},
	{-2003.345703125, -278.2822265625, 35.414142608643, text="Teraz już aby prosto na parking koło ośrodka"},
	{-2003.1904296875, -211.2890625, 35.804706573486},
	{-2004.5595703125, -83.720703125, 35.364368438721},
	{-2020.369140625, -67.73046875, 35.265510559082},
	{-2040.955078125, -67.8154296875, 35.265354156494},
	{-2047.330078125, -96.9345703125, 35.261833190918, size=5},
}

function render()
	if state == "showing" then
		progress = progress + 0.1
		y,_,_ = interpolateBetween(sh, 0, 0, sh/2-175, 0, 0, progress, "Linear")
		guiSetPosition(browser, sw/2-275, y, false)
		if progress >= 1 then
			state = "showed"
			showCursor(true, false)
		end
	elseif state == "hiding" then
		progress = progress + 0.1
		y,_,_ = interpolateBetween(sh/2-175, 0, 0, sh, 0, 0, progress, "Linear")
		guiSetPosition(browser, sw/2-275, y, false)
		if progress >= 1 then
			state = "hidden"
			removeEventHandler("onClientRender", getRootElement(), render)
			destroyElement(browser)
			showCursor(false)
		end
	end
end

function createPrawkoWindow()
	if isElement(browser) then return end
	browser = guiCreateBrowser(sw/2-275, y, 550, 350, true, true, false)
	addEventHandler("onClientBrowserCreated", guiGetBrowser(browser), loadPrawko)
end
addEvent("createPrawkoWindow", true)
addEventHandler("createPrawkoWindow", getRootElement(), createPrawkoWindow)

function loadPrawko()
	loadBrowserURL(source, "http://mta/local/html/prawko.html")
	progress = 0
	state = "showing"
	addEventHandler("onClientRender", getRootElement(), render)
	setTimer(function ()
		local pjA = getElementData(localPlayer, "user:pjA")
		local pjB = getElementData(localPlayer, "user:pjB")
		local pjC = getElementData(localPlayer, "user:pjC")
		executeBrowserJavascript(guiGetBrowser(browser), "setKategorie("..pjA..", "..pjB..", "..pjC..")")
	end, 300, 1)
end

function close()
	progress = 0
	state = "hiding"
end
addEvent("closeWindow", true)
addEventHandler("closeWindow", getRootElement(), close)

function processPrawko(kat)
	if kat == "a" then
		if getElementData(localPlayer, "user:pjA") > 0 then
			exports.rpg_noti:createNotification("error", "Posiadasz już prawo jazdy kategorii A")
			return
		end
		if getElementData(localPlayer, "user:money") < 150 then
			exports.rpg_noti:createNotification("error", "Nie stać cię na ten egzamin")
			return
		end
		if #getElementsWithinColShape(pj_cs) ~= 0 then
			exports.rpg_noti:createNotification("error", "Coś blokuje bramę wyjazdową")
			return
		end
		setElementData(localPlayer, "user:money", getElementData(localPlayer, "user:money") - 150)
		triggerServerEvent("createPrawkoVehA", localPlayer)
		startPrawkoA()
	elseif kat == "b" then
		if getElementData(localPlayer, "user:pjB") > 0 then
			exports.rpg_noti:createNotification("error", "Posiadasz już prawo jazdy kategorii B")
			return
		end
		if getElementData(localPlayer, "user:money") < 100 then
			exports.rpg_noti:createNotification("error", "Nie stać cię na ten egzamin")
			return
		end
		if #getElementsWithinColShape(pj_cs) ~= 0 then
			exports.rpg_noti:createNotification("error", "Coś blokuje bramę wyjazdową")
			return
		end
		setElementData(localPlayer, "user:money", getElementData(localPlayer, "user:money") - 100)
		triggerServerEvent("createPrawkoVehB", localPlayer)
		startPrawkoB()
	elseif kat == "c" then
		if getElementData(localPlayer, "user:pjC") > 0 then
			exports.rpg_noti:createNotification("error", "Posiadasz już prawo jazdy kategorii C")
			return
		end
		if getElementData(localPlayer, "user:money") < 300 then
			exports.rpg_noti:createNotification("error", "Nie stać cię na ten egzamin")
			return
		end
		if #getElementsWithinColShape(pj_cs) ~= 0 then
			exports.rpg_noti:createNotification("error", "Coś blokuje bramę wyjazdową")
			return
		end
		setElementData(localPlayer, "user:money", getElementData(localPlayer, "user:money") - 300)
		triggerServerEvent("createPrawkoVehC", localPlayer)
		startPrawkoC()
	end
end
addEvent("processPrawko", true)
addEventHandler("processPrawko", getRootElement(), processPrawko)


-- Kategoria A
function startPrawkoA()
	pkt = 1
	createPunktA()
	setElementData(localPlayer, "onPrawko", true)
end

function createPunktA()
	local x,y,z = pja_pkt[pkt][1], pja_pkt[pkt][2], pja_pkt[pkt][3]
	local size = pja_pkt[pkt].size or 2
	marker = createMarker(x,y,z, "checkpoint", size, 255, 0, 0, 150)
	if pkt == #pja_pkt then
		setMarkerIcon(marker, "finish")
	else
		local x,y,z = pja_pkt[pkt+1][1], pja_pkt[pkt+1][2], pja_pkt[pkt+1][3]
		setMarkerTarget(marker, x,y,z)
	end
	blip = createBlip(x,y,z,41)
	addEventHandler("onClientMarkerHit", marker, hitPunktA)
end

function destroyPunkt()
	if isElement(marker) then destroyElement(marker) end
	if isElement(blip) then destroyElement(blip) end
end
addEvent("destroyPunkt", true)
addEventHandler("destroyPunkt", getRootElement(), destroyPunkt)

function hitPunktA(hit)
	if pkt == #pja_pkt then
		outputChatBox("#ffc800Egzaminator: #eeeeeeGratulacje! Zdajesz ten egzamin!", 255, 255, 255, true)
		triggerServerEvent("destroyPrawkoVehA", localPlayer)
		triggerServerEvent("backToSchool", localPlayer, localPlayer)
		destroyPunkt()
		triggerServerEvent("givePrawkoA", localPlayer)
		return
	end
	destroyPunkt()
	if pja_pkt[pkt].text then
		outputChatBox("#ffc800Egzaminator: #eeeeee"..pja_pkt[pkt].text, 255, 255, 255, true)
	end
	pkt = pkt + 1
	createPunktA()
end

-- Kategoria B
function startPrawkoB()
	pkt = 1
	createPunktB()
	setElementData(localPlayer, "onPrawko", true)
end

function createPunktB()
	local x,y,z = pjb_pkt[pkt][1], pjb_pkt[pkt][2], pjb_pkt[pkt][3]
	local size = pjb_pkt[pkt].size or 3
	marker = createMarker(x,y,z, "checkpoint", size, 255, 0, 0, 150)
	if pkt == #pjb_pkt then
		setMarkerIcon(marker, "finish")
	else
		local x,y,z = pjb_pkt[pkt+1][1], pjb_pkt[pkt+1][2], pjb_pkt[pkt+1][3]
		setMarkerTarget(marker, x,y,z)
	end
	blip = createBlip(x,y,z,41)
	addEventHandler("onClientMarkerHit", marker, hitPunktB)
end

function hitPunktB(hit)
	if pkt == #pjb_pkt then
		outputChatBox("#ffc800Egzaminator: #eeeeeeGratulacje! Zdajesz ten egzamin!", 255, 255, 255, true)
		triggerServerEvent("destroyPrawkoVehB", localPlayer)
		triggerServerEvent("backToSchool", localPlayer, localPlayer)
		destroyPunkt()
		triggerServerEvent("givePrawkoB", localPlayer)
		return
	end
	destroyPunkt()
	if pjb_pkt[pkt].text then
		outputChatBox("#ffc800Egzaminator: #eeeeee"..pjb_pkt[pkt].text, 255, 255, 255, true)
	end
	pkt = pkt + 1
	createPunktB()
end

-- Kategoria C
function startPrawkoC()
	pkt = 1
	createPunktC()
	setElementData(localPlayer, "onPrawko", true)
end

function createPunktC()
	local x,y,z = pjc_pkt[pkt][1], pjc_pkt[pkt][2], pjc_pkt[pkt][3]
	local size = pjc_pkt[pkt].size or 3
	marker = createMarker(x,y,z, "checkpoint", size, 255, 0, 0, 150)
	if pkt == #pjc_pkt then
		setMarkerIcon(marker, "finish")
	else
		local x,y,z = pjc_pkt[pkt+1][1], pjc_pkt[pkt+1][2], pjc_pkt[pkt+1][3]
		setMarkerTarget(marker, x,y,z)
	end
	blip = createBlip(x,y,z,41)
	addEventHandler("onClientMarkerHit", marker, hitPunktC)
end

function hitPunktC(hit)
	if pkt == #pjc_pkt then
		outputChatBox("#ffc800Egzaminator: #eeeeeeGratulacje! Zdajesz ten egzamin!", 255, 255, 255, true)
		triggerServerEvent("destroyPrawkoVehC", localPlayer)
		triggerServerEvent("backToSchool", localPlayer, localPlayer)
		destroyPunkt()
		triggerServerEvent("givePrawkoC", localPlayer)
		return
	end
	destroyPunkt()
	if pjc_pkt[pkt].text then
		outputChatBox("#ffc800Egzaminator: #eeeeee"..pjc_pkt[pkt].text, 255, 255, 255, true)
	end
	pkt = pkt + 1
	createPunktC()
end

setElementData(localPlayer, "onPrawko", false)

fileDelete("prawko_client.lua")