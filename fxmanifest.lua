fx_version 'bodacious' 
game 'gta5'

author 'Niknock HD'
description 'NKHD Tsunami'
version '1.2.0'

ui_page 'html/index.html'

client_scripts {'tsunami_client.lua', 'config.lua'}
server_scripts {'tsunami_server.lua', 'config.lua'}
shared_script 'config.lua'

files {
	'html/index.html',
	'flood_initial.xml',
	'water.xml'
}

data_file 'WATER_FILE' 'flood_initial.xml'
data_file 'WATER_FILE' 'water.xml'
