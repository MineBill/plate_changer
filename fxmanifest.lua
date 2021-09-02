fx_version "cerulean"
game "gta5"

files {
    "html/**.*"
}

ui_page "html/index.html"

shared_scripts {
    "@es_extended/imports.lua",
    "config.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server.lua",
}

client_script "client.lua"

dependencies {
    "es_extended"
}