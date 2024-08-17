fx_version 'cerulean'
game 'gta5'

author 'YourName'
description 'Codex Flitsmeister - Speed Camera Warnings'
version '1.1.0'

server_script 'server/main.lua'
client_script 'client/main.lua'

shared_scripts {
    'config.lua'
}

dependencies {
    'es_extended'
}
