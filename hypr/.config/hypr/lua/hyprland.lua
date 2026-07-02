-- ~/.config/hypr/hyprland.lua

-- Importar archivos de la subcarpeta 'lua'
-- NOTA: No pongas la extensión .lua, solo el nombre del archivo
require("lua.monitors")
require("lua.env")
require("lua.autostart")
require("lua.theme")     -- Es importante cargar theme antes que binds si define variables
require("lua.settings")
require("lua.inputs")
require("lua.binds")
require("lua.rules")

-- Mensaje opcional en los logs para confirmar carga
print("Configuración de Hyprland cargada con éxito")