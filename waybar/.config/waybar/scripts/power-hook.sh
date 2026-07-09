#!/bin/bash
# Este script corre en segundo plano y avisa a waybar solo cuando cambia el perfil
powerprofilesctl monitor | while read line; do
    pkill -SIGRTMIN+8 waybar
done