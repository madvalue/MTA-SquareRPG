--[[
	Style chodzenia
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local window
local showed = false
local styles = {
	{"Domyślny", 0},
	{"Kobieta1", 129},
	{"Kobieta2", 133},
	{"Sexowna kobieta", 132},
	{"Gangster1", 121},
	{"Gangster2", 122},
	{"Stara kobieta", 134},
	{"Stary facet", 120},
	{"Facet", 118}
}


function createStylePanel()
	if showed then return end
	local sw, sh = guiGetScreenSize()
	window = guiCreateWindow(sw-350, sh/2-250, 300, 500, "Style chodzenia", false)
	grid = guiCreateGridList(0, 0.06, 1, 0.75, true, window)
	col1 = guiGridListAddColumn(grid, "Styl chodzenia", 0.9)
	button1 = guiCreateButton(0, 0.82, 1, 0.07, "Ustaw styl", true, window)
	addEventHandler("onClientGUIClick", button1, selectStyle, false)
	addEventHandler("onClientGUIDoubleClick", grid, selectStyle, false)
	button2 = guiCreateButton(0, 0.9, 1, 0.07, "Zamknij", true, window)
	addEventHandler("onClientGUIClick", button2, hideStylePanel, false)
	showCursor(true)
	showed = true
	for i,v in ipairs(styles) do
		local row = guiGridListAddRow(grid)
		guiGridListSetItemText(grid, row, col1, v[1], false, false)
		guiGridListSetItemData(grid, row, col1, v[2], false, false)
	end
end
addCommandHandler("ws", createStylePanel)

function hideStylePanel()
	removeEventHandler("onClientGUIClick", button1, selectStyle, false)
	removeEventHandler("onClientGUIDoubleClick", grid, selectStyle, false)
	removeEventHandler("onClientGUIClick", button2, hideStylePanel, false)
	destroyElement(window)
	showCursor(false)
	showed = false
end

function selectStyle()
	local item = guiGridListGetSelectedItem(grid)
	if item == -1 then return end
		local styl = guiGridListGetItemData(grid, item, 1)
		local styl_text = guiGridListGetItemText(grid, item, 1)
		exports.rpg_noti:createNotification("info", "Zmieniasz swój styl chodzenia na: "..styl_text)
		setPedWalkingStyle(localPlayer, styl)
		hideStylePanel()
end

fileDelete("styles_client.lua")