# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repo structure

Each top-level directory is a **GNU Stow package**. Its internal tree mirrors `$HOME`, so `stow -t $HOME <pkg>` creates the correct symlinks. Example: `waybar/.config/waybar/style.css` → `~/.config/waybar/style.css`.

Managed packages: `btop`, `cava`, `Code`, `hypr`, `kitty`, `nautilus`, `swaync`, `wal`, `waybar`, `wlogout`, `wofi`, `yay`, `yazi`, `ZapZap`, `zed`, `zsh`.

`stow.sh` is a one-time migration script — it moves an existing `~/.config/<app>` into the repo and stows it. It is not run repeatedly.

## Theming system (pywal)

**All color theming flows from pywal.** When a wallpaper is applied, pywal generates `~/.cache/wal/colors*` files that every app sources at runtime. Nothing in this repo hardcodes colors directly — they reference pywal variables.

Wallpaper → color pipeline:
1. `awww img <wall>` sets the wallpaper (daemon: `awww-daemon`)
2. `wal -i <wall> --saturate 0.8` generates `~/.cache/wal/colors*`
3. The `wal/postrun` script regenerates `btop`'s `wal.theme` from the new palette
4. `swaync-client --reload-css` and `pywalfox update` hot-reload other consumers

Pywal template files live in `wal/.config/wal/templates/`:
- `colors-hyprland` → `~/.cache/wal/colors-hyprland` (sourced by `hyprland.conf` and `hyprlock.conf`)
- `btop.theme` → used by postrun to build `btop/themes/wal.theme`

Waybar and swaync source colors via `@import url('~/.cache/wal/colors-waybar.css')`. The file `waybar/.config/waybar/colors-waybar.css` is a **manual fallback/snapshot** used when pywal hasn't run yet — it is not the live color source.

## Hyprland

Config entrypoint: `hypr/.config/hypr/hyprland.conf`

There is a parallel **Lua config** (`hyprland.lua` + `lua/`) that mirrors the `.conf` file using Hyprland's newer Lua API. The `.conf` file is the active config; the Lua files are a work-in-progress rewrite. Do not edit both for the same setting — pick one.

Lua module layout:
- `lua/theme.lua` — sources pywal colors, defines `_G.terminal`, `_G.fileManager`, `_G.menu`
- `lua/settings.lua` — `general`, `decoration`, `animations`, `dwindle`
- `lua/binds.lua` — all keybinds
- `lua/autostart.lua` — `exec-once` equivalents
- `lua/monitors.lua`, `lua/inputs.lua`, `lua/rules.lua`, `lua/env.lua`

Key binds defined in `hyprland.conf`:
- `SUPER+Q` terminal, `SUPER+E` file manager (kitty+yazi), `SUPER+SPACE` wofi launcher / pypr term scratchpad
- `SUPER+G` pypr music scratchpad (pulsemixer), `SUPER+T` pypr taskbar scratchpad (btop)
- `ALT+W` wallpaper picker, `ALT+R` random wallpaper, `ALT+B` waybar theme switcher, `ALT+A` waybar toggle
- `SUPER+F1/F2/F3` power profiles (power-saver / balanced / performance)
- `Print` region screenshot, `CTRL+Print` window, `ALT+Print` full output (all via hyprshot)

Pyprland scratchpads (`pyprland.toml`): `term` (kitty-dropterm), `music` (kitty+pulsemixer), `taskbar` (kitty+btop).

## Waybar

Config: `waybar/.config/waybar/config` (JSON) + `style.css`

`style.css` imports `colors-waybar.css` which must be kept in sync with pywal output. Modules use pill-shaped containers via `border-radius: 99px`.

Module groups:
- Left: `custom/notification` (swaync toggle), workspaces, pacman update count, tray
- Center: clock with calendar tooltip
- Right: `group/expand` (drawer: temp/cpu/mem/gpu/disk), `group/tools` (colorpicker/screenshot/language), `group/misc` (network/bluetooth/audio/backlight), `group/power` (power-profiles-daemon/battery)

Scripts in `waybar/scripts/`:
- `refresh.sh` — toggle waybar on/off
- `select.sh` — wofi-based theme switcher; copies from `waybar/themes/<name>/` into `style.css` and `config`, then restarts waybar. Theme assets previewed as images from `waybar/assets/`.
- `gpu-nvidia.sh`, `gpu-integrated.sh` — polled by the `custom/gpu-nvidia` module
- `power-hook.sh` — called by power-profiles-daemon module

When adding a new waybar module, define it in `config` and style it in `style.css` using `@color*` variables from the pywal import.

## Wofi

Config: `wofi/.config/wofi/config`

Three style variants, each paired with a custom wofi config file:
- `style.css` + `config` — default app launcher (drun mode)
- `style-wallpaper.css` + `wallpaper` config — used by `hypr/wallpaper.sh` for wallpaper picker
- `style-waybar.css` + `waybar` config — used by `waybar/scripts/select.sh` for theme picker

All three styles pull colors from `~/.cache/wal/colors-waybar.css` via `@import`.

## Swaync

Config: `swaync/.config/swaync/config.json` + `style.css`

Positioned bottom-left. Widgets order: mpris → title → notifications → volume → backlight → buttons-grid. The buttons-grid contains quick-action toggles (mute, mic, network, bluetooth, DND, lock, reboot, shutdown).

`style.css` imports pywal colors from `../../.cache/wal/colors-waybar.css` (relative path). Reload with `swaync-client --reload-css` after pywal runs. The `swaync/refresh.sh` script handles this.

## Kitty

Config: `kitty/.config/kitty/kitty.conf`

Theme is managed by `current-theme.conf` (included at the top), which pywal can overwrite. The active theme file is not committed — `kitty.conf.bak` is a backup of the base config.

Font: `CodeNewRoman Nerd Font Propo` (also used in hyprlock, swaync, and waybar tooltips for icon consistency).

## Yazi

Config: `yazi/.config/yazi/yazi.toml`

Three-column layout with ratio `[1, 3, 4]`. Sorted alphabetically, directories first. Hidden files off by default. Keymap customizations in `keymap.toml`.

## Wallpaper scripts

Two scripts, both in `hypr/scripts/` and `hypr/`:
- `wallpaper.sh` — **interactive**: opens wofi wallpaper picker → applies with `awww` → runs pywal → reloads swaync, pywalfox, cava (updates gradient colors via `sed`)
- `scripts/random_wallpaper.sh` — **non-interactive**: picks random file from `~/wallpapers/walls/`, applies with `awww`, runs pywal, calls `wal/postrun`, reloads swaync + pywalfox, then `hyprctl reload`

Wallpapers live at `~/wallpapers/walls/`. Current wallpaper is saved as `~/wallpapers/pywallpaper.jpg`.

## Applying changes

After editing a config file in this repo, the symlink means the change is live immediately — no stow re-run needed. Exceptions:
- **Hyprland**: `hyprctl reload` (or `ALT+A` for waybar, bound keybinds for other apps)
- **Waybar**: `pkill waybar && waybar` or `ALT+A`
- **Swaync**: `swaync-client --reload-css` or `ALT+R`
- **Kitty**: reloads on `CTRL+SHIFT+F5` or automatically
- **Wofi/Wlogout**: stateless, picks up changes on next launch
