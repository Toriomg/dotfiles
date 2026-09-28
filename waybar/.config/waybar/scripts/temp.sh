#!/bin/sh
# waybar: temperatura del paquete de CPU.
#   hot     -> solo imprime a partir de 70 °C (píldora fuera del desplegable)
#   drawer  -> solo imprime por debajo de 70 °C (dentro del desplegable)
# Sin salida, waybar oculta el módulo, así que solo uno de los dos es visible.
z=$(grep -l x86_pkg_temp /sys/class/thermal/thermal_zone*/type | head -1)
t=$(( $(cat "${z%type}temp") / 1000 ))

if [ "$t" -ge 70 ]; then
  [ "$1" = "hot" ] || exit 0
else
  [ "$1" = "hot" ] && exit 0
fi

i=""
[ "$t" -ge 50 ] && i=""
[ "$t" -ge 75 ] && i=""
echo "$i $t°C"
