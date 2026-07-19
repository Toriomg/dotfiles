#!/bin/bash

# Directorio de tus fondos de pantalla
WALLPAPER_DIR="$HOME/wallpapers/walls"
CACHE_DIR="$HOME/.cache/awww"

# 1. Seleccionar un fondo aleatorio
# Buscamos archivos, los mezclamos (shuf) y tomamos el primero (head)
SELECTED_WALL=$(find "${WALLPAPER_DIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | shuf -n 1)

# Si no encuentra nada, salir
[ -z "$SELECTED_WALL" ] && exit 1

if [ "$1" == "--init" ]; then
    # Al iniciar sesión: Sin transición y borrando caché para evitar parpadeos
    TRANSITION="none"
    [ -d "$CACHE_DIR" ] && rm -rf "$CACHE_DIR"
else
    # Manualmente: Con transición bonita
    TRANSITION="any" # Puedes cambiar "any" por "outer", "simple", "wipe", etc.
fi

# 4. Arrancar el demonio si no está corriendo
if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    # Esperar un instante a que el demonio responda
    while ! awww query >/dev/null 2>&1; do
        sleep 0.1
    done
fi

# 2. Aplicar con awww
awww img "$SELECTED_WALL" \
    --transition-type "$TRANSITION" \
    --transition-fps 165 \
    --transition-duration 0.8

# 3. Generar colores con Pywal
wal -i "$SELECTED_WALL" --saturate 0.7

# 4. Actualizar componentes que dependen de Pywal
swaync-client --reload-css
pywalfox update 2>/dev/null
bash ~/.config/wal/postrun
pkill swayosd-server; swayosd-server &
# 5. (Opcional) Copiar como fondo actual para persistencia
cp "$SELECTED_WALL" ~/wallpapers/pywallpaper.jpg

# 6. Forzar a Hyprland a recargar los colores si es necesario
# Como tienes 'source = ~/.cache/wal/colors-hyprland', a veces Hyprland 
# necesita un ligero refresco para leer el archivo actualizado
hyprctl reload
