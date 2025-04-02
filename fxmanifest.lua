fx_version 'adamant'

game 'gta5'

author 'Pablo'

version '1.0.0'

shared_script({
    "config.lua",
});

server_scripts({
    "server.lua",
});

client_scripts({
    -- RageUI
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua", 
    -- Fichier client
    "client.lua",
});


version '5.4'

escrow_ignore {
    "config.lua",
}

lua54 "on"

dependency '/assetpacks'