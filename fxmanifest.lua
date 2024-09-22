fx_version 'bodacious' 
game 'gta5'

author 'Niknock HD'
description 'NKHD Tsunami'
version '1.0'

ui_page 'html/index.html'

client_script 'tsunami_client.lua'
server_script 'tsunami_server.lua'

files {
	'html/index.html',
	'flood_initial.xml',
	'water.xml'
}

data_file 'WATER_FILE' 'flood_initial.xml'
data_file 'WATER_FILE' 'water.xml'
