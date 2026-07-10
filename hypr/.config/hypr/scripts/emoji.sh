#!/usr/bin/env bash
rofimoji \
    --selector wofi \
    --selector-args="--conf $HOME/.config/wofi/emoji --style $HOME/.config/wofi/style-emoji.css" \
    --clipboarder wl-copy \
    --action copy \
    --hidden-descriptions
