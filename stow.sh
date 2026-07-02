#!/usr/bin/env bash
APPS=("btop" "bruno" "cava" "Code" "hypr" "kitty" "nautilus" "swaync" "wal" "waybar" "wlogout" "wofi" "yay" "yazi" "ZapZap" "zed" "zsh" )

# 1. MODO ESTRICTO (El script se detendrá inmediatamente si algo falla)
set -euo pipefail
IFS=$'\n\t'

# 2. FUNCIÓN DE TRATAMIENTO DE ERRORES CATASTRÓFICOS
cleanup() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo "❌ [ERROR CRÍTICO] El script ha fallado inesperadamente (Código: $exit_code)."
        echo "Revisa el estado de tus carpetas para asegurarte de que todo está bien."
    fi
    exit $exit_code
}
trap cleanup EXIT # Ejecuta 'cleanup' si el script se interrumpe o falla

# 3. COMPROBACIÓN DE DEPENDENCIAS
if ! command -v stow &> /dev/null; then
    echo "❌ Error: 'stow' no está instalado. Por favor, instálalo antes de continuar."
    exit 1
fi

# 4. VARIABLES PRINCIPALES (Usando $HOME en lugar de ~ para evitar fallos)
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo "🚀 Iniciando la migración segura de configuraciones a $DOTFILES_DIR"
echo "------------------------------------------------------------------"

# Asegurar que la carpeta raíz de los dotfiles existe
mkdir -p "$DOTFILES_DIR"

for app in "${APPS[@]}"; do
    echo "🔍 Verificando: $app"
    
    # Rutas absolutas para evitar problemas sin importar desde dónde ejecutes el script
    SRC_DIR="$CONFIG_DIR/$app"
    DEST_APP_DIR="$DOTFILES_DIR/$app"
    DEST_CONFIG_DIR="$DEST_APP_DIR/.config"
    DEST_DIR="$DEST_CONFIG_DIR/$app"

    # COMPROBACIÓN A: ¿Existe la configuración original?
    if [ ! -e "$SRC_DIR" ]; then
        echo "  ⚠️  Saltando: No se encontró la carpeta original en $SRC_DIR"
        echo "------------------------------------------------------------------"
        continue
    fi

    # COMPROBACIÓN B: ¿Ya es un enlace simbólico? (Evita romper lo que ya está migrado)
    if [ -L "$SRC_DIR" ]; then
        echo "  ✅ Saltando: $app ya es un enlace simbólico. ¡Ya estaba migrado!"
        echo "------------------------------------------------------------------"
        continue
    fi

    # COMPROBACIÓN C: ¿El destino ya existe en dotfiles? (Evita sobreescribir o anidar carpetas accidentalmente)
    if [ -e "$DEST_DIR" ]; then
        echo "  ❌ Error preventivo: Ya existe $DEST_DIR en tus dotfiles."
        echo "     Se omitirá $app para evitar pérdida de datos. Revísalo manualmente."
        echo "------------------------------------------------------------------"
        continue
    fi

    # --- INICIO DEL PROCESO SEGURO DE MIGRACIÓN ---
    
    # Paso 1: Crear la estructura exacta necesaria para stow
    echo "  📁 Creando estructura: $DEST_CONFIG_DIR"
    mkdir -p "$DEST_CONFIG_DIR"

    # Paso 2: Mover la carpeta original al destino
    echo "  📦 Moviendo configuración a dotfiles..."
    mv "$SRC_DIR" "$DEST_CONFIG_DIR/"

    # Paso 3: Crear el enlace simbólico entrando al directorio dotfiles
    echo "  🔗 Aplicando enlace con stow..."
    
    # Entramos a dotfiles silenciosamente, ejecutamos stow y salimos
    pushd "$DOTFILES_DIR" > /dev/null
    
    # stow -t (target) asegura que se enlace en tu $HOME correctamente
    if stow -t "$HOME" "$app"; then
        echo "  ✅ ¡$app migrado y enlazado con éxito!"
    else
        echo "  ❌ Falló al ejecutar stow para $app. Por favor revisa manualmente."
    fi
    
    popd > /dev/null
    echo "------------------------------------------------------------------"
done

# Si llegamos aquí sin activar el 'trap' de error, todo fue perfecto
trap - EXIT 
echo "🎉 Proceso de migración finalizado de forma 100% segura."