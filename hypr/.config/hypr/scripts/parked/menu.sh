#!/bin/sh
# Menu de la tecla Menu: lista de acciones en wofi.
# Se le puede pasar la entrada como argumento (util para probarlo sin abrir wofi).
run=${XDG_RUNTIME_DIR:-/tmp}
estado() { [ -e "$run/hypr-modo-$1" ] && echo "  ·  activo"; }

# Ventana suelta en un workspace especial: la primera vez la lanza, luego la
# muestra y la esconde. Es el scratchpad nativo de Hyprland, sin pyprland.
scratch() {
  hyprctl clients -j | grep -q "special:$1" || hyprctl dispatch exec "[workspace special:$1 silent] $2"
  hyprctl dispatch togglespecialworkspace "$1"
}

sel=$1
[ -n "$sel" ] || sel=$(printf '%s\n' \
  "  Terminal desplegable" \
  "  Monitor del sistema" \
  "  Mezclador de audio" \
  "  Modo juego$(estado juego)" \
  "  Modo presentación$(estado presentacion)" \
  "  Historial del portapapeles" \
  | wofi --dmenu --prompt "Menú" --width 420 --height 320)

case $sel in
  *Terminal*)      scratch term kitty ;;
  *Monitor*)       scratch monitor "kitty -e btop" ;;
  *Mezclador*)     scratch audio "kitty -e pulsemixer" ;;
  *juego*)         "$(dirname "$0")/mode.sh" juego ;;
  *presentación*)  "$(dirname "$0")/mode.sh" presentacion ;;
  *portapapeles*)  cliphist list | wofi --dmenu --prompt "Portapapeles" --width 700 --height 450 \
                     | cliphist decode | wl-copy ;;
esac
