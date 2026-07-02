#!/bin/bash

# Verificar si nvidia-smi está disponible
if ! command -v nvidia-smi &> /dev/null; then
    echo "󰢮 N/A"
    exit 0
fi

# Obtener datos de la GPU
usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1)
#temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader 2>/dev/null | head -n1)
#mem_used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader 2>/dev/null | head -n1 | sed 's/ MiB//')
#mem_total=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader 2>/dev/null | head -n1 | sed 's/ MiB//')

# Calcular porcentaje de memoria
if [ -n "$mem_used" ] && [ -n "$mem_total" ] && [ "$mem_total" -gt 0 ]; then
    mem_percent=$((mem_used * 100 / mem_total))
else
    mem_percent="--"
fi

# Mostrar información
if [ -n "$usage" ]; then
    if [ -n "$temp" ] && [ "$mem_percent" != "--" ]; then
        echo "󰢮 ${usage}%  ${temp}°C  ${mem_percent}%"
    elif [ -n "$temp" ]; then
        echo "󰢮 ${usage}%  ${temp}°C"
    else
        echo "󰢮 ${usage}%"
    fi
else
    echo "󰢮 --"
fi
