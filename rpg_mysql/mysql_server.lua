--[[
	Połączenie z bazą danych MySQL
	@author value <value2k@gmail.com>
	Nie masz prawa użyć tego kodu bez mojej zgody
]]
local mysql
function mysql_connect()
	mysql = dbConnect("mysql", "dbname=nazwa bazy;host=localhost", "nazwa użytkownika", "hasło", "share=1")
	if not mysql then
		outputDebugString("[rpg_mysql] Connection: false")
	else
		outputDebugString("[rpg_mysql] Connection: true")
	end
end
addEventHandler("onResourceStart", resourceRoot, mysql_connect)

function mysql_query(...)
	local qh = dbQuery(mysql, ...)
	--outputDebugString("[value_mysql] QUERY: "..(...))
	if not qh then return false end
	local result, num_affected_rows, last_insert_id = dbPoll(qh, -1)
	return result, num_affected_rows, last_insert_id
end
