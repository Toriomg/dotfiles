#!/bin/bash
bat_dir=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)
bat=$(cat "$bat_dir/capacity" 2>/dev/null || echo "?")
status=$(cat "$bat_dir/status" 2>/dev/null || echo "Unknown")
profile=$(powerprofilesctl get 2>/dev/null || echo "balanced")

case $profile in
  performance) picon="" ;;
  power-saver) picon="" ;;
  *)           picon="" ;;
esac

if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
  icon=""; cls="charging"
elif [ "$bat" -le 15 ] 2>/dev/null; then
  icon=""; cls="critical"
elif [ "$bat" -le 30 ] 2>/dev/null; then
  icon=""; cls="warning"
elif [ "$bat" -ge 80 ] 2>/dev/null; then icon=""
elif [ "$bat" -ge 60 ] 2>/dev/null; then icon=""
elif [ "$bat" -ge 40 ] 2>/dev/null; then icon=""
elif [ "$bat" -ge 20 ] 2>/dev/null; then icon=""
else icon=""
fi

echo "{\"text\":\"$picon  $icon  $bat%\",\"class\":\"${cls:-}\",\"tooltip\":\"Batería: $bat%\nEstado: $status\nPerfil: $profile\"}"
