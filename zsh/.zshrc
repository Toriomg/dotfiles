# --- CONFIGURACIÓN DE ZSH (Hector) ---

# 1. Plugins (Instalados vía pacman)
# Proporcionan resaltado de comandos y sugerencias estilo buscador


autoload -Uz compinit && compinit
zstyle ':completion:*' menu select 
source ~/.config/zsh/plugins/git.plugin.zsh
source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh 2>/dev/null
source ~/.config/zsh/plugins/zsh-autopair/zsh-autopair.plugin.zsh 2>/dev/null
source ~/.config/zsh/plugins/zsh-auto-notify/zsh-auto-notify.plugin.zsh 2>/dev/null
source ~/.config/zsh/plugins/zsh-bd/zsh-bd.plugin.zsh 2>/dev/null
source ~/.config/zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.plugin.zsh 2>/dev/null

# 2. Historial
HISTFILE=~/.zsh_history
HISTSIZE=90000
SAVEHIST=9999999990000
setopt SHARE_HISTORY      # Compartir historial entre terminales
setopt APPEND_HISTORY     # Añadir al historial, no sobrescribir
setopt HIST_IGNORE_DUPS   # No guardar comandos duplicados seguidos

# 3. Navegación e interfaz
setopt AUTO_CD                     # Escribir nombre de carpeta para entrar
setopt PROMPT_SUBST                # Permitir funciones en el prompt

# 4. Inicialización de herramientas
clear && myfetch -d -c 16 -C "󰣇  "
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# 5. Tus Alias (Portados de Bash)
alias ls='eza --icons --group-directories-first'
alias ll='eza -l -h --icons --group-directories-first --git'
alias la='eza -l -a -h --icons --group-directories-first --git'
alias ltree='eza --tree --icons'
alias pacup='sudo pacman -Rns $(pacman -Qdtq)'
alias grep='grep --color=auto'
alias pool='clear && asciiquarium'
alias f='clear && myfetch -d -f -c 16 -C "󰣇  "'
alias bye='sudo shutdown -h now'
alias loop='sudo reboot'
alias h='dbus-launch Hyprland'
alias fonts='fc-list -f "%{family}\n"'
alias tasks='btm'
alias Docs="cd ~/Documents && nvim"
alias Settings="cd ~/.config/hypr && nvim"
alias spot="ncspot"
alias untar="tar -xf"
alias n="nvim"
alias cd="z"
alias vpn="sudo -E gpclient connect --browser default myvpn.uc3m.es"

alias c="claude"
alias cc="claude --continue"
alias cr="claude --resume"
# 6. Función lt mejorada (con niveles dinámicos)
lt() {
  local nivel="${1:-2}"
  eza --tree --icons --group-directories-first --level="$nivel" "${@:2}"
}

# 7. NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 8. Colores de Pywal
[ -f ~/.cache/wal/sequences ] && (cat ~/.cache/wal/sequences &)

# 9. Variables de Entorno
export EDITOR='vim'
export VISUAL='vim'
export ANDROID_HOME=/home/hector/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH=$PATH:$(npm config get prefix)/bin

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# 1. Asegurar que las rutas de funciones de Arch estén presentes
fpath=(/usr/share/zsh/functions/Zle /usr/share/zsh/site-functions $fpath)

# 2. Usar los widgets internos (estos no necesitan 'autoload')
# Esto permite que las flechas funcionen normal y con historial
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history

# 3. Si quieres la búsqueda inteligente (escribir 'ls' y que filtre):
# Cargamos estos específicamente asegurando la ruta
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Define el código para la tecla Suprimir
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

bindkey "^[[H" beginning-of-line  # Tecla Inicio
bindkey "^[[F" end-of-line        # Tecla Fin


source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
#ZSH_HIGHLIGHT_STYLES[command]='fg=14,bold'
#ZSH_HIGHLIGHT_STYLES[unknown-command]='fg=15,bold'
#ZSH_HIGHLIGHT_STYLES[argument]='fg=11'
#ZSH_HIGHLIGHT_STYLES[path]='fg=5'
#ZSH_HIGHLIGHT_STYLES[option]='fg=4'
#ZSH_HIGHLIGHT_STYLES[quotation]='fg=6'
#ZSH_HIGHLIGHT_STYLES[redirection]='fg=1,bold'
#ZSH_HIGHLIGHT_STYLES[error]='fg=1,bold,underline'
#ZSH_HIGHLIGHT_STYLES[comment]='fg=8'
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh
export PATH="$HOME/.local/bin:$PATH"
