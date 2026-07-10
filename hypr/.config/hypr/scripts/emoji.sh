#!/usr/bin/env bash

DATA_DIR="/usr/lib/python3.14/site-packages/picker/data"

chosen=$(cat "$DATA_DIR"/emojis_smileys_emotion.csv \
             "$DATA_DIR"/emojis_people_body.csv \
             "$DATA_DIR"/emojis_animals_nature.csv \
             "$DATA_DIR"/emojis_food_drink.csv \
             "$DATA_DIR"/emojis_travel_places.csv \
             "$DATA_DIR"/emojis_activities.csv \
             "$DATA_DIR"/emojis_objects.csv \
             "$DATA_DIR"/emojis_symbols.csv \
             "$DATA_DIR"/emojis_flags.csv \
    | awk '{print $1}' \
    | wofi --dmenu \
           --conf "$HOME/.config/wofi/emoji" \
           --style "$HOME/.config/wofi/style-emoji.css" \
           --prompt "")

[ -n "$chosen" ] && wl-copy "$chosen"
