fx_version "adamant"
game "gta5"
description 'Prize Pool'
author "Drive"
version '1.0.0'
lua54 'yes'

ui_page "html/index.html"

files {
	'html/css/main.css',
	'html/js/main.js',
	'html/img/*',
	'html/index.html'
}

server_scripts {
	'sv_config.lua',
	-- 'server.lua',
}

client_scripts {
	'cl_config.lua',
	'client.lua',
}
