#!/bin/bash

# Detectar tipo de GPU integrada
if lsmod | grep -q i915; then
    # Intel
    gpu_name="Intel"
    icon="󰾴"
    if command -v intel_gpu_top &> /dev/null; then
        # Usar intel_gpu_top si está disponible
        usage=$(timeout 1 sudo intel_gpu_top -o - 2>/dev/null | awk 'NR==2 {print $8}' | sed 's/%//')
        if [ -n "$usage" ]; then
            echo "${icon} ${usage}%"
        else
            echo "${icon} --"
        fi
    else
        # Alternativa: usar /sys/class/drm
        if [ -f /sys/class/drm/card0/gt/gt0/rc6_enable ]; then
            echo "${icon} --"
        else
            echo "${icon} N/A"
        fi
    fi
elif lsmod | grep -q amdgpu; then
    # AMD
    gpu_name="AMD"
    icon="󰹑"
    echo "${icon} --"
else
    # No detectada
    echo "󰢮 --"
fi
