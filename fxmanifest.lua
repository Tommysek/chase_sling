fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

game 'gta5'

dependencies {
    'ox_lib',
    'ox_inventory',
}

client_scripts {
    '@ox_lib/init.lua',
    'data/weapons.lua',
    'data/carry.lua',
    'modules/utils.lua',
    'modules/weapons.lua',
    'modules/carry.lua',
    'modules/vehicles.lua',
    'modules/inventory.lua',
}

server_script 'server.lua'