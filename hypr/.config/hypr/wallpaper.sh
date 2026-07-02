#!/bin/bash
WALLPAPER_DIR="$HOME/wallpapers/walls"

menu() {
    find "${WALLPAPER_DIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | awk '{print "img:"$0}'
}

main() {
    choice=$(menu | wofi -c ~/.config/wofi/wallpaper -s ~/.config/wofi/style-wallpaper.css --show dmenu --prompt "Select Wallpaper:" -n)
    [ -z "$choice" ] && exit 1

    selected_wallpaper=$(echo "$choice" | sed 's/^img://')

    # 1. Aplicar fondo
    awww img "$selected_wallpaper" --transition-type any --transition-fps 60 --transition-duration .5

    # 2. Generar colores con Pywal (AQUÍ ESTÁ EL TRUCO DE LEGIBILIDAD)
    # --backend colorthief: Genera colores mucho más bonitos y vivos
    # --saturate 0.7: Asegura que no sean colores "lavados"
    wal -i "$selected_wallpaper"  --saturate 0.8

    # 3. Recargar apps
    swaync-client --reload-css
    pywalfox update
    
    # Recargar Kitty (Pywal ya lo hace si tienes el include en kitty.conf)
    # Si no lo tienes, descomenta la siguiente línea:
    # cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf

    # 4. Configurar Cava
    source "$HOME/.cache/wal/colors.sh"
    cava_config="$HOME/.config/cava/config"
    sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" $cava_config
    sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" $cava_config
    pkill -USR2 cava 2>/dev/null

    # Guardar copia
    cp "$selected_wallpaper" ~/wallpapers/pywallpaper.jpg 
}

main
