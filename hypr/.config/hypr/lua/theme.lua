-- Definir programas globales para usarlos en binds.lua
_G.terminal = "kitty"
_G.fileManager = "kitty yazi"
_G.menu = "wofi -n"

-- Cargar colores de Pywal (esto importa las variables $colorX al entorno de Hyprland)
hl.config({
    source = { "~/.cache/wal/colors-hyprland" }
})