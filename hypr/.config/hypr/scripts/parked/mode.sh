#!/bin/sh
# Modos rapidos para la tecla Menu. Cada modo es un interruptor: el fichero de
# estado dice si esta puesto, y volver a llamarlo lo deshace.
mode=$1
state=${XDG_RUNTIME_DIR:-/tmp}/hypr-modo-$mode
notify() { notify-send -t 2500 -a Hyprland "$1" "$2"; }

case $mode in
  juego)
    if [ -e "$state" ]; then
      rm -f "$state"
      hyprctl reload                        # vuelve a la config del repo
      powerprofilesctl set balanced
      notify "Modo juego apagado" "Blur y animaciones de vuelta"
    else
      touch "$state"
      # con el parser Lua los ajustes se cambian con eval, no con keyword
      hyprctl eval 'hl.config({ decoration = { blur = { enabled = false }, rounding = 0 }, animations = { enabled = false } })' >/dev/null
      powerprofilesctl set performance
      notify "Modo juego" "Sin blur ni animaciones · perfil rendimiento"
    fi
    ;;
  presentacion)
    if [ -e "$state" ]; then
      rm -f "$state"
      setsid -f hypridle >/dev/null 2>&1
      setsid -f wlsunset -l 40.4 -L -3.7 -t 4500 -T 6500 >/dev/null 2>&1
      swaync-client --dnd-off >/dev/null
      notify "Modo presentación apagado" "Vuelve el apagado de pantalla y las notificaciones"
    else
      touch "$state"
      pkill hypridle                        # la pantalla no se apaga
      pkill wlsunset                        # sin tono cálido, los colores como son
      notify "Modo presentación" "Pantalla siempre encendida · sin notificaciones"
      sleep 1                               # que se vea el aviso antes del silencio
      swaync-client --dnd-on >/dev/null
    fi
    ;;
  *)
    echo "uso: ${0##*/} juego|presentacion" >&2
    exit 1
    ;;
esac
