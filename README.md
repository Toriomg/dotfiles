# dotfiles

Arch Linux · Hyprland · minimalism

My personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Every top-level directory is a Stow package whose internal tree mirrors `$HOME`.

---

## Packages

| Package | Config path | Purpose |
|---|---|---|
| `btop` | `~/.config/btop/` | System monitor with pywal-generated theme |
| `cava` | `~/.config/cava/` | Audio visualizer, gradient synced to wallpaper |
| `Code` | `~/.config/Code/` | VS Code user settings |
| `hypr` | `~/.config/hypr/` | Hyprland WM, hyprlock, hypridle, pyprland |
| `kitty` | `~/.config/kitty/` | Terminal emulator |
| `nautilus` | `~/.config/nautilus/` | File manager settings |
| `starship` | `~/.config/starship.toml` | Shell prompt |
| `swaync` | `~/.config/swaync/` | Notification center |
| `swayosd` | `~/.config/swayosd/` | On-screen display for volume/brightness |
| `wal` | `~/.config/wal/` | Pywal templates and postrun script |
| `waybar` | `~/.config/waybar/` | Status bar |
| `wlogout` | `~/.config/wlogout/` | Logout screen |
| `wofi` | `~/.config/wofi/` | App launcher and pickers |
| `yay` | — | AUR helper config |
| `yazi` | `~/.config/yazi/` | Terminal file manager |
| `ZapZap` | `~/.config/ZapZap/` | WhatsApp client |
| `zed` | `~/.config/zed/` | Zed editor settings |
| `zsh` | `~/.zshrc` | Shell config |

---

## Setup

**Prerequisites:** `git`, `stow`, and the target applications installed via pacman/AUR.

```sh
git clone https://github.com/Toriomg/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow -t $HOME <package>      # stow a single package
stow -t $HOME btop hypr waybar swaync wofi kitty zsh   # or several at once
```

`stow.sh` is a one-time migration script for moving an existing `~/.config/<app>` into the repo and replacing it with a symlink. It is not meant to be run repeatedly.

---

## Theming

All colors flow from **[pywal](https://github.com/dylanaraps/pywal)**. Setting a wallpaper regenerates the entire palette — no manual color editing needed.

```
awww img <wallpaper>               # set wallpaper via swww daemon
wal -i <wallpaper> --saturate 0.8  # generate ~/.cache/wal/colors*
```

Pywal writes color files that every app sources at runtime:

- **Hyprland / Hyprlock** — via `colors-hyprland` template → `~/.cache/wal/colors-hyprland`
- **Waybar / Swaync / Wofi / Swayosd** — via `@import url('~/.cache/wal/colors-waybar.css')`
- **Btop** — `wal/postrun` regenerates `btop/themes/wal.theme`
- **Kitty** — `current-theme.conf` (overwritten by pywal, not committed)
- **Firefox** — `pywalfox update` (called in postrun)

Wallpaper scripts live in `hypr/.config/hypr/`:
- `wallpaper.sh` — interactive wofi picker, applies wallpaper + reloads all consumers
- (random wallpaper bound to `ALT+R`)

Wallpapers are stored at `~/wallpapers/walls/`.

---

## Hyprland

Config entrypoint: `hypr/.config/hypr/hyprland.lua` (Lua API — no `.conf` file).

| Lua module | Contents |
|---|---|
| `lua/theme.lua` | Pywal color import, terminal/fileManager/menu globals |
| `lua/settings.lua` | General, decoration, animations, dwindle |
| `lua/binds.lua` | All keybinds |
| `lua/autostart.lua` | `exec-once` daemons |
| `lua/monitors.lua` | Monitor layout |
| `lua/inputs.lua` | Keyboard/mouse/touchpad |
| `lua/rules.lua` | Window rules |
| `lua/env.lua` | Environment variables |

### Key bindings

| Bind | Action |
|---|---|
| `SUPER+Q` | Terminal |
| `SUPER+E` | File manager |
| `SUPER+SPACE` | App launcher (wofi) |
| `SUPER+C` | Close window |
| `SUPER+V` | Toggle float |
| `SUPER+F` | Fullscreen |
| `SUPER+L` | Lock screen (hyprlock) |
| `SUPER+M` | Exit Hyprland |
| `ALT+TAB` | Logout menu (wlogout) |
| `ALT+W` | Wallpaper picker |
| `ALT+R` | Random wallpaper |
| `ALT+B` | Waybar theme switcher |
| `ALT+A` | Toggle waybar |
| `SUPER+.` | Emoji picker |
| `Print` | Region screenshot |
| `CTRL+Print` | Window screenshot |
| `ALT+Print` | Full output screenshot |

---

## Waybar

Config: `waybar/.config/waybar/config` + `style.css`

Module layout:

- **Left:** notification toggle (swaync), workspaces, pacman update count, tray
- **Center:** clock with calendar tooltip
- **Right:** expand drawer (CPU temp / CPU / RAM / GPU / disk), tools (color picker / screenshot / language), network · bluetooth · audio · backlight, power profile · battery

`waybar/.config/waybar/colors-waybar.css` is a fallback snapshot used before pywal has run — the live source is always `~/.cache/wal/colors-waybar.css`.

---

## Design principles

- **SF Pro Text** for all text surfaces; **JetBrains Mono Nerd Font** wherever icon glyphs are needed.
- Three color roles from pywal: `$color7` (foreground), `$color8` (muted), `$color9` (accent). Error states use hardcoded `rgba(220, 70, 70, 1.0)`.
- Pill-shaped interactive elements (`border-radius: 99px`).
- Semi-transparent surfaces (`alpha(@background, 0.65)`).
- No drop shadows. Blur is structural (5 passes, size 3–5).

---

## Applying changes

Symlinks mean edits are live immediately. Some apps need a reload signal:

| App | Reload command |
|---|---|
| Hyprland | `hyprctl reload` |
| Waybar | `pkill waybar && waybar` or `ALT+A` |
| Swaync | `swaync-client --reload-css` |
| Kitty | `CTRL+SHIFT+F5` |
| Wofi / Wlogout | Stateless — picks up changes on next launch |

---
**NOTE:** In this repo i dont follow git's good practices