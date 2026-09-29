#!/usr/bin/env bash
# Zoom del cursor via thumbwheel del MX Master 3S (logid -> este script)
STATE="/tmp/hypr_zoom_factor"
STEP=0.15
MIN=1.0
MAX=4.0

current=$(cat "$STATE" 2>/dev/null || echo "$MIN")

if [ "$1" = "in" ]; then
    new=$(awk -v c="$current" -v s="$STEP" -v m="$MAX" 'BEGIN{v=c+s; print (v>m)?m:v}')
else
    new=$(awk -v c="$current" -v s="$STEP" -v m="$MIN" 'BEGIN{v=c-s; print (v<m)?m:v}')
fi

echo "$new" > "$STATE"
hyprctl eval "hl.config({cursor = {zoom_factor = $new}})"
